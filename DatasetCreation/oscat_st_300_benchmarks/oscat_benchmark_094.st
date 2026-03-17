VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF NOT x THEN state := 0; ELSE state := 0;
2:
    IF NOT x THEN state := 1;
END_CASE