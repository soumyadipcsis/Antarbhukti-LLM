VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    IF x OR y THEN state := 1; ELSE state := 5;
2:
    state := 0;
3:
    IF x AND y THEN state := 2;
4:
    IF NOT y THEN state := 4;
5:
    IF NOT y THEN state := 4; ELSE state := 4;
END_CASE