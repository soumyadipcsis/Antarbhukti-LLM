VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 2; ELSE state := 2;
1:
    IF x AND y THEN state := 0;
2:
    IF x OR y THEN state := 1; ELSE state := 4;
3:
    state := 4;
4:
    state := 3;
5:
    IF x THEN state := 4; ELSE state := 0;
END_CASE