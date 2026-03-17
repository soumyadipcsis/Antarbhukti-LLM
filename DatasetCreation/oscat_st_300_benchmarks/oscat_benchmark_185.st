VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 3; ELSE state := 4;
1:
    IF x OR y THEN state := 1; ELSE state := 3;
2:
    IF NOT y THEN state := 2;
3:
    state := 0;
4:
    state := 1;
END_CASE