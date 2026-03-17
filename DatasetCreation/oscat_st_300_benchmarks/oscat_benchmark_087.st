VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 1;
1:
    IF x AND y THEN state := 3;
2:
    state := 5;
3:
    IF NOT y THEN state := 5;
4:
    IF x OR y THEN state := 2;
5:
    state := 1;
END_CASE