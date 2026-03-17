VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 0;
1:
    state := 0;
2:
    IF x THEN state := 2; ELSE state := 0;
END_CASE