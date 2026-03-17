VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1;
1:
    IF x OR y THEN state := 4;
2:
    IF x THEN state := 5;
3:
    state := 5;
4:
    IF x AND y THEN state := 3; ELSE state := 2;
5:
    IF x THEN state := 0;
END_CASE