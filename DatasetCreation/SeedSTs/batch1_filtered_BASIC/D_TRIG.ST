(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.1	19. feb 2008
programmer 	hugo
tested by	tobias

this block is similar to the IEC Standard R_trig and F_trig but it monitors a DWORD, WORD or Byte Variable instead and generated an Output Pulse for one cycle only when the input has changed.
an additional output x (Dword) will state the chage of the input.
Example: the input has chaged from 0001 to 0010 then the output x will be 2.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK D_TRIG

(*Group:Default*)


VAR_INPUT
	IN :	DWORD;
END_VAR


VAR_OUTPUT
	Q :	BOOL;
	X :	DWORD;
END_VAR


VAR
	last_in :	DWORD;
END_VAR


(*@KEY@: WORKSHEET
NAME: D_TRIG
IEC_LANGUAGE: ST
*)
Q := in <> last_in;
X := UDINT_TO_DWORD(DWORD_TO_UDINT(in) - DWORD_TO_UDINT(last_in));
last_in := in;


(* revision history

hm 	4.09.2007		rev 1.0
	original version released

hm	19. feb. 2008	rev 1.1
	performance improvement
*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
