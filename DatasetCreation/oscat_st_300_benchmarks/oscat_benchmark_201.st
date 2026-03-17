VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    state := 1;
2:
    state := 3;
3:
    state := 1;
4:
    IF NOT x THEN state := 2;
END_CASE