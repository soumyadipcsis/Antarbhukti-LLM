VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1;
1:
    state := 3;
2:
    state := 0;
3:
    state := 2;
4:
    state := 2;
END_CASE