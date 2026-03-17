VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    state := 0;
2:
    state := 0;
3:
    IF x AND y THEN state := 4; ELSE state := 1;
4:
    IF x OR y THEN state := 0;
END_CASE