VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 2; ELSE state := 2;
1:
    state := 1;
2:
    state := 1;
3:
    state := 1;
END_CASE