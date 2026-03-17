VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 2;
1:
    state := 2;
2:
    state := 1;
END_CASE