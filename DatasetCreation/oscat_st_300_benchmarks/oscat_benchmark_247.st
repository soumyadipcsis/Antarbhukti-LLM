VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    IF NOT y THEN state := 2;
2:
    state := 0;
END_CASE