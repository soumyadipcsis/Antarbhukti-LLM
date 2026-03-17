VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    state := 0;
2:
    state := 0;
3:
    IF NOT x THEN state := 0;
END_CASE