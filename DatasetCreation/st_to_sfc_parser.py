"""
st_to_sfc_parser.py
====================
Parses OSCAT Structured Text (.ST) files and converts them into a
Sequential Function Chart (SFC) dictionary representation.

Supported patterns
------------------
  Pattern A  -  Explicit CASE state machines
  Pattern B  -  Priority IF/ELSIF/ELSE continuous evaluation,
                including promotion of nested inner IFs to top-level SFC steps.

Returns
-------
  dict  -  {"steps": [...], "transitions": [...],
            "variables": [...], "initial_step": "..."}
  dict  -  {"error": "COMPLEX_LOGIC_REQUIRES_LLM"}  on unrecognised complexity.

No external dependencies - standard library only.
"""

import re
import sys
from typing import Any


# ---------------------------------------------------------------------------
# Whitespace / string utilities
# ---------------------------------------------------------------------------

def _norm(s: str) -> str:
    """Collapse whitespace runs to single space and strip."""
    return re.sub(r'\s+', ' ', s).strip()


def _strip_comments(text: str) -> str:
    """Remove (* ... *) block comments (one nesting level)."""
    text = re.sub(r'\(\*@[^*]*\*\)', '', text, flags=re.DOTALL)
    text = re.sub(r'\(\*.*?\*\)', ' ', text, flags=re.DOTALL)
    return text


# ---------------------------------------------------------------------------
# Variable extraction
# ---------------------------------------------------------------------------

_VAR_BLOCK_RE = re.compile(
    r'\b(VAR_INPUT|VAR_OUTPUT|VAR_IN_OUT|VAR)\b(.*?)END_VAR',
    re.DOTALL | re.IGNORECASE,
)
_VAR_NAME_RE = re.compile(r'^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:', re.MULTILINE)


def extract_variables(source: str) -> list:
    """Return deduplicated ordered variable names from all VAR* blocks."""
    seen = {}
    for m in _VAR_BLOCK_RE.finditer(source):
        for vm in _VAR_NAME_RE.finditer(m.group(2)):
            seen[vm.group(1)] = None
    return list(seen.keys())


# ---------------------------------------------------------------------------
# Worksheet extraction
# ---------------------------------------------------------------------------

_WORKSHEET_RE = re.compile(
    r'\(\*@KEY@:\s*WORKSHEET.*?\*\)(.*?)'
    r'(?:\(\*@KEY@:\s*END_WORKSHEET\s*\*\)|END_FUNCTION_BLOCK|END_FUNCTION)',
    re.DOTALL | re.IGNORECASE,
)


def extract_worksheet(source: str):
    m = _WORKSHEET_RE.search(source)
    return m.group(1) if m else None


# ---------------------------------------------------------------------------
# Lightweight ST tokeniser / AST builder
# ---------------------------------------------------------------------------

class _Tok:
    """Character-level tokeniser that understands IF/ELSIF/ELSE/END_IF."""

    def __init__(self, text: str):
        self.text = text
        self.pos = 0
        self.length = len(text)

    def _skip_ws(self):
        while self.pos < self.length and self.text[self.pos] in ' \t\r\n':
            self.pos += 1

    def _peek_kw(self, *keywords):
        self._skip_ws()
        for kw in keywords:
            end = self.pos + len(kw)
            chunk = self.text[self.pos:end]
            if chunk.upper() == kw.upper():
                after = self.text[end:end + 1] if end < self.length else ''
                if not after or not (after.isalnum() or after == '_'):
                    return kw
        return None

    def _consume_kw(self, kw: str):
        self._skip_ws()
        self.pos += len(kw)

    def parse_block(self, *stop_kws):
        """Parse statements until one of stop_kws is peeked; return AST list."""
        stmts = []
        while self.pos < self.length:
            self._skip_ws()
            if not self.pos < self.length:
                break
            if self._peek_kw(*stop_kws):
                break
            if self._peek_kw('IF'):
                stmts.append(self._parse_if())
            else:
                stmt = self._read_simple_stmt()
                if stmt:
                    stmts.append({'type': 'stmt', 'code': stmt})
        return stmts

    def _parse_if(self):
        self._consume_kw('IF')
        condition = self._read_until('THEN').strip()
        self._consume_kw('THEN')
        body = self.parse_block('ELSIF', 'ELSE', 'END_IF')

        branches = [{'condition': condition, 'body': body}]

        while self._peek_kw('ELSIF'):
            self._consume_kw('ELSIF')
            cond = self._read_until('THEN').strip()
            self._consume_kw('THEN')
            b = self.parse_block('ELSIF', 'ELSE', 'END_IF')
            branches.append({'condition': cond, 'body': b})

        else_body = []
        if self._peek_kw('ELSE'):
            self._consume_kw('ELSE')
            else_body = self.parse_block('END_IF')

        self._consume_kw('END_IF')
        self._skip_ws()
        if self.pos < self.length and self.text[self.pos] == ';':
            self.pos += 1

        return {'type': 'if', 'branches': branches, 'else': else_body}

    def _read_until(self, *stop_kws):
        buf = []
        while self.pos < self.length:
            if self._peek_kw(*stop_kws):
                break
            buf.append(self.text[self.pos])
            self.pos += 1
        return ''.join(buf)

    def _read_simple_stmt(self):
        buf = []
        while self.pos < self.length:
            ch = self.text[self.pos]
            self.pos += 1
            buf.append(ch)
            if ch == ';':
                return _norm(''.join(buf))
            so_far = ''.join(buf).strip().upper()
            for kw in ('ELSIF', 'ELSE', 'END_IF', 'END_CASE', 'CASE', 'IF'):
                if so_far.endswith(kw):
                    rollback = len(kw)
                    self.pos -= rollback
                    buf = buf[:-rollback]
                    return _norm(''.join(buf))
        return _norm(''.join(buf))


# ---------------------------------------------------------------------------
# AST helpers
# ---------------------------------------------------------------------------

def _ast_to_code(nodes):
    parts = []
    for n in nodes:
        if n['type'] == 'stmt':
            parts.append(n['code'])
        elif n['type'] == 'if':
            for br in n['branches']:
                parts.append(_ast_to_code(br['body']))
            if n.get('else'):
                parts.append(_ast_to_code(n['else']))
    return ' '.join(p for p in parts if p)


# ---------------------------------------------------------------------------
# Guard builder
# ---------------------------------------------------------------------------

def _to_guard(condition: str) -> str:
    """Convert raw ST boolean condition string to a normalised guard expression."""
    condition = _norm(condition)

    # Already has an explicit comparison operator
    if re.search(r'[<>]=?|<>|==|:=', condition):
        return re.sub(r':=', '==', condition)

    tokens = re.split(r'\b(AND|OR)\b', condition, flags=re.IGNORECASE)
    parts = []
    for tok in tokens:
        tok = tok.strip()
        if not tok:
            continue
        if tok.upper() in ('AND', 'OR'):
            parts.append(tok.upper())
            continue
        m = re.match(r'^NOT\s+(.+)$', tok, re.IGNORECASE)
        if m:
            parts.append(f'{m.group(1).strip()} == FALSE')
        else:
            parts.append(f'{tok} == TRUE')
    return ' '.join(parts)


def _negate_guard(guard: str) -> str:
    """Return the logical negation of a guard expression."""
    if re.search(r'\bAND\b|\bOR\b', guard):
        return f'NOT ({guard})'
    if '== TRUE' in guard:
        return guard.replace('== TRUE', '== FALSE')
    if '== FALSE' in guard:
        return guard.replace('== FALSE', '== TRUE')
    return f'NOT ({guard})'


# ---------------------------------------------------------------------------
# Byte-code → step name mapping  (extend as needed)
# ---------------------------------------------------------------------------

_STATUS_BYTE_NAMES = {
    '100': 'InitCycle',
    '101': 'ManualLogic',
    '102': 'AutoLogic',
    '103': 'ResetLogic',
}


def _step_name_from_stmts(nodes, fallback: str) -> str:
    """Derive a readable step name from STATUS/STATE byte assignment."""
    for n in nodes:
        if n['type'] == 'stmt':
            m = re.search(r'\bBYTE#(\w+)', n['code'], re.IGNORECASE)
            if m:
                code = m.group(1)
                return _STATUS_BYTE_NAMES.get(code, f'Step_{code}')
    return fallback


# ---------------------------------------------------------------------------
# Pattern A – CASE state machine
# ---------------------------------------------------------------------------

def _split_case_labels(case_body: str):
    label_re = re.compile(
        r'(?:^|\n)\s*([A-Za-z_0-9][A-Za-z0-9_,\s]*)\s*:\s*(?!=)',
        re.MULTILINE,
    )
    positions = [(m.start(), m.group(1).strip(), m.end())
                 for m in label_re.finditer(case_body)]
    if not positions:
        return []
    result = []
    for i, (start, label, body_start) in enumerate(positions):
        end = positions[i + 1][0] if i + 1 < len(positions) else len(case_body)
        result.append((label.rstrip(',').strip(), case_body[body_start:end]))
    return result


def parse_pattern_a(worksheet: str, variables: list) -> dict:
    ws = _strip_comments(worksheet)

    case_re = re.compile(
        r'\bCASE\s+([A-Za-z_][A-Za-z0-9_.]*)\s+OF\s*(.*?)\s*END_CASE\s*;?',
        re.DOTALL | re.IGNORECASE,
    )
    m = case_re.search(ws)
    if not m:
        return {'error': 'COMPLEX_LOGIC_REQUIRES_LLM'}

    state_var = m.group(1).strip()
    label_blocks = _split_case_labels(m.group(2))
    if not label_blocks:
        return {'error': 'COMPLEX_LOGIC_REQUIRES_LLM'}

    assign_re = re.compile(
        rf'\bIF\s+(.+?)\s+THEN\s+.*?'
        rf'\b{re.escape(state_var)}\s*:=\s*([A-Za-z_0-9#]+)\s*;',
        re.DOTALL | re.IGNORECASE,
    )
    direct_re_tmpl = rf'\b{re.escape(state_var)}\s*:=\s*([A-Za-z_0-9#]+)\s*;'

    steps = []
    transitions = []

    for label, body in label_blocks:
        trans = []
        cleaned = body
        for a in assign_re.finditer(body):
            cond = _norm(a.group(1))
            nxt = a.group(2).strip()
            trans.append({'src': label, 'tgt': nxt, 'guard': _to_guard(cond)})
            cleaned = cleaned.replace(a.group(0), '', 1)
        direct_re = re.compile(direct_re_tmpl, re.IGNORECASE)
        for a in direct_re.finditer(cleaned):
            nxt = a.group(1).strip()
            if not any(t['tgt'] == nxt for t in trans):
                trans.append({'src': label, 'tgt': nxt, 'guard': 'TRUE'})
        cleaned = direct_re.sub('', cleaned)

        steps.append({'name': label, 'function': _norm(cleaned)})
        transitions.extend(trans)

    preamble = ws[:m.start()].strip()
    if preamble:
        steps.insert(0, {'name': 'InitCycle', 'function': _norm(preamble)})
        first = label_blocks[0][0]
        transitions.insert(0, {'src': 'InitCycle', 'tgt': first, 'guard': 'TRUE'})

    epilogue = ws[m.end():].strip()
    if epilogue:
        steps.append({'name': 'ApplyOutput', 'function': _norm(epilogue)})
        has_out = {t['src'] for t in transitions}
        for s in steps:
            if s['name'] not in has_out and s['name'] != 'ApplyOutput':
                transitions.append({'src': s['name'], 'tgt': 'ApplyOutput', 'guard': 'TRUE'})

    initial = steps[0]['name'] if steps else 'InitCycle'
    return {'steps': steps, 'transitions': transitions,
            'variables': variables, 'initial_step': initial}


# ---------------------------------------------------------------------------
# Pattern B – Priority IF/ELSIF with nested-IF promotion
# ---------------------------------------------------------------------------

def _is_inner_if_only(nodes) -> bool:
    """True when a branch body consists exclusively of nested IF nodes."""
    return bool(nodes) and all(n['type'] == 'if' for n in nodes)


def _build_branch_steps(outer_guard: str, body, branch_idx: int):
    """
    Expand one IF/ELSIF branch body into (steps, transitions).

    If the branch body is ALL nested IFs, promote each inner IF to its own
    step with a compound guard (outer AND inner).

    Transitions use the sentinel src='<PARENT>'; caller replaces with real name.
    """
    # --- Case 1: body is only nested IFs (e.g. ELSIF ENQ body) -------------
    if _is_inner_if_only(body):
        steps = []
        transitions = []
        neg_inner_so_far = []

        for i, if_node in enumerate(body):
            for j, br in enumerate(if_node['branches']):
                raw_cond = _norm(br['condition'])
                pos_guard = _to_guard(raw_cond)

                # compound = outer AND (NOT prev inner guards) AND this inner
                compound_parts = (
                    ([outer_guard] if outer_guard and outer_guard != 'TRUE' else [])
                    + neg_inner_so_far
                    + [pos_guard]
                )
                full_guard = ' AND '.join(compound_parts) or 'TRUE'

                func_code = ' '.join(
                    n['code'] for n in br['body'] if n['type'] == 'stmt'
                )
                name = _step_name_from_stmts(br['body'],
                                             f'Branch_{branch_idx}_{i}_{j}')

                steps.append({'name': name, 'function': func_code})
                transitions.append({'src': '<PARENT>', 'tgt': name,
                                     'guard': full_guard})

                neg_inner_so_far.append(_negate_guard(pos_guard))

        # Fallthrough from InitCycle when no inner condition fires:
        # all inner negations AND outer condition
        if neg_inner_so_far:
            fallthrough_parts = (
                ([outer_guard] if outer_guard and outer_guard != 'TRUE' else [])
                + neg_inner_so_far
            )
            fallthrough_guard = ' AND '.join(fallthrough_parts) or 'TRUE'
        else:
            fallthrough_guard = outer_guard or 'TRUE'

        return steps, transitions, fallthrough_guard

    # --- Case 2: mixed / plain statements – single step --------------------
    func_parts = []
    for n in body:
        if n['type'] == 'stmt':
            func_parts.append(n['code'])
        elif n['type'] == 'if':
            for br in n['branches']:
                func_parts.extend(s['code'] for s in br['body']
                                   if s['type'] == 'stmt')
            if n.get('else'):
                func_parts.extend(s['code'] for s in n['else']
                                   if s['type'] == 'stmt')

    func_code = ' '.join(func_parts).strip()
    name = _step_name_from_stmts(body, f'Branch_{branch_idx}')

    return (
        [{'name': name, 'function': func_code}],
        [{'src': '<PARENT>', 'tgt': name, 'guard': outer_guard}],
        None,  # no inner fallthrough
    )


def parse_pattern_b(worksheet: str, variables: list) -> dict:
    """
    Parse a priority IF/ELSIF worksheet into SFC steps and transitions.

    Structure produced
    ------------------
    InitCycle (preamble)
      |
      +--[guard1]--> Step_A --> ApplyOutput
      |
      +--[guard1_neg AND guard2]--> Step_B --> ApplyOutput
      |
      +--[guard1_neg AND guard2_neg AND inner_guard]--> Step_C --> ApplyOutput
      |
      +--[all_neg]--> ApplyOutput   (fallthrough: no branch fired)
      |
    ApplyOutput (epilogue) --> InitCycle
    """
    ws_raw = _strip_comments(worksheet)

    m_if = re.search(r'\bIF\b', ws_raw, re.IGNORECASE)
    if not m_if:
        code = _norm(ws_raw)
        return {
            'steps': [{'name': 'InitCycle', 'function': code},
                       {'name': 'ApplyOutput', 'function': ''}],
            'transitions': [
                {'src': 'InitCycle', 'tgt': 'ApplyOutput', 'guard': 'TRUE'},
                {'src': 'ApplyOutput', 'tgt': 'InitCycle', 'guard': 'TRUE'},
            ],
            'variables': variables,
            'initial_step': 'InitCycle',
        }

    preamble_raw = ws_raw[:m_if.start()].strip()

    tok = _Tok(ws_raw[m_if.start():])
    try:
        ast = tok.parse_block()
    except Exception:
        return {'error': 'COMPLEX_LOGIC_REQUIRES_LLM'}

    top_if = None
    post_stmts = []
    for node in ast:
        if node['type'] == 'if' and top_if is None:
            top_if = node
        else:
            post_stmts.append(node)

    if top_if is None:
        return {'error': 'COMPLEX_LOGIC_REQUIRES_LLM'}

    # InitCycle preamble step
    steps = [{'name': 'InitCycle', 'function': _norm(preamble_raw)}]
    transitions = []
    all_leaf_names = []
    neg_outer = []           # accumulates negated outer guards
    fallthrough_guards = []  # accumulates all "no-branch-fired" conditions

    for idx, br in enumerate(top_if['branches']):
        raw_cond = _norm(br['condition'])
        pos_guard = _to_guard(raw_cond)

        # Compound outer guard: NOT(all previous) AND this
        outer_parts = neg_outer + [pos_guard]
        compound_outer = ' AND '.join(p for p in outer_parts if p and p != 'TRUE') or 'TRUE'

        br_steps, br_trans, inner_fallthrough = _build_branch_steps(
            compound_outer, br['body'], idx
        )

        for t in br_trans:
            t['src'] = 'InitCycle'

        steps.extend(br_steps)
        transitions.extend(br_trans)
        all_leaf_names.extend(s['name'] for s in br_steps)

        neg_outer.append(_negate_guard(pos_guard))
        if inner_fallthrough:
            fallthrough_guards.append(inner_fallthrough)

    # ELSE branch
    if top_if.get('else'):
        else_guard = ' AND '.join(neg_outer) if neg_outer else 'TRUE'
        else_steps, else_trans, _ = _build_branch_steps(else_guard, top_if['else'], -1)
        for t in else_trans:
            t['src'] = 'InitCycle'
        steps.extend(else_steps)
        transitions.extend(else_trans)
        all_leaf_names.extend(s['name'] for s in else_steps)

    # Overall fallthrough guard: all outer conditions false
    outer_fallthrough = ' AND '.join(neg_outer) if neg_outer else 'TRUE'
    # Combine with inner fallthroughs (union of paths where nothing fired)
    all_fallthroughs = [outer_fallthrough] + fallthrough_guards
    # The guard for InitCycle -> ApplyOutput direct path is a compound OR
    if len(all_fallthroughs) == 1:
        ft_guard = all_fallthroughs[0]
    else:
        # Each element represents one path where no step fired; combine with OR
        ft_guard = '(' + ') OR ('.join(all_fallthroughs) + ')'

    # ApplyOutput epilogue
    epilogue_parts = [n['code'] for n in post_stmts if n['type'] == 'stmt']
    for n in post_stmts:
        if n['type'] == 'if':
            epilogue_parts.append(_ast_to_code([n]))
    epilogue_code = ' '.join(p for p in epilogue_parts if p).strip()
    steps.append({'name': 'ApplyOutput', 'function': epilogue_code})

    # Leaf steps -> ApplyOutput
    for name in all_leaf_names:
        transitions.append({'src': name, 'tgt': 'ApplyOutput', 'guard': 'TRUE'})

    # InitCycle -> ApplyOutput (fallthrough)
    transitions.append({'src': 'InitCycle', 'tgt': 'ApplyOutput', 'guard': ft_guard})

    # ApplyOutput -> InitCycle loop
    transitions.append({'src': 'ApplyOutput', 'tgt': 'InitCycle', 'guard': 'TRUE'})

    # Deduplicate steps
    seen_names = set()
    unique_steps = []
    for s in steps:
        if s['name'] not in seen_names:
            seen_names.add(s['name'])
            unique_steps.append(s)

    return {
        'steps': unique_steps,
        'transitions': transitions,
        'variables': variables,
        'initial_step': 'InitCycle',
    }


# ---------------------------------------------------------------------------
# Top-level dispatcher
# ---------------------------------------------------------------------------

def parse_st_to_sfc(filepath: str) -> dict:
    """
    Parse an OSCAT .ST file and return an SFC dict.

    Parameters
    ----------
    filepath : str
        Path to the .ST source file.

    Returns
    -------
    dict
        {"steps": [...], "transitions": [...], "variables": [...],
         "initial_step": "..."}
        or {"error": "COMPLEX_LOGIC_REQUIRES_LLM"} on failure.
    """
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as fh:
            source = fh.read()
    except OSError as exc:
        return {'error': f'FILE_READ_ERROR: {exc}'}

    variables = extract_variables(source)

    worksheet = extract_worksheet(source)
    if worksheet is None:
        return {'error': 'COMPLEX_LOGIC_REQUIRES_LLM'}

    ws_clean = _strip_comments(worksheet)

    if re.search(r'\bCASE\b', ws_clean, re.IGNORECASE):
        return parse_pattern_a(worksheet, variables)

    if re.search(r'\bIF\b', ws_clean, re.IGNORECASE):
        return parse_pattern_b(worksheet, variables)

    # Plain sequential code - single-step
    return {
        'steps': [{'name': 'InitCycle', 'function': _norm(ws_clean)}],
        'transitions': [],
        'variables': variables,
        'initial_step': 'InitCycle',
    }


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

if __name__ == '__main__':
    import json
    import os

    if len(sys.argv) < 2:
        print('Usage: python st_to_sfc_parser.py <path/to/file.st>')
        sys.exit(1)

    input_path = sys.argv[1]
    result = parse_st_to_sfc(input_path)

    # Build output path: somefile.st -> somefile_sfc.txt
    base, _ = os.path.splitext(input_path)
    output_path = base + '_sfc.txt'

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(result, f, indent=2)

    print(f'Written to {output_path}')