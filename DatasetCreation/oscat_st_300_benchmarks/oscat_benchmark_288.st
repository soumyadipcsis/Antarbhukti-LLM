VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 0; ELSE state := 1;
1:
    state := 2;
2:
    state := 4;
3:
    IF x OR y THEN state := 4; ELSE state := 4;
4:
    state := 3;
END_CASE