VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 2;
1:
    state := 3;
2:
    IF x OR y THEN state := 2;
3:
    state := 0;
END_CASE