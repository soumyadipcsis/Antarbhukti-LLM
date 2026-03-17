VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 0;
1:
    state := 1;
2:
    state := 2;
END_CASE