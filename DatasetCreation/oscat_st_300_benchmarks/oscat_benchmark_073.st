VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    state := 2;
2:
    IF x THEN state := 1;
3:
    IF x OR y THEN state := 3;
END_CASE