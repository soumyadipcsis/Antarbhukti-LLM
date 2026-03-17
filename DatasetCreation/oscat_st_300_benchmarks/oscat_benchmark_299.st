VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 5;
1:
    state := 3;
2:
    IF x OR y THEN state := 1; ELSE state := 5;
3:
    IF x AND y THEN state := 0;
4:
    IF x OR y THEN state := 2;
5:
    IF x OR y THEN state := 3; ELSE state := 2;
END_CASE