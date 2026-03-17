VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 3; ELSE state := 2;
1:
    state := 0;
2:
    IF NOT y THEN state := 1;
3:
    state := 1;
END_CASE