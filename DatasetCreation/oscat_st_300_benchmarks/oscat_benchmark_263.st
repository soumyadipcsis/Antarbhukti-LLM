VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 2;
1:
    state := 0;
2:
    IF x OR y THEN state := 2;
END_CASE