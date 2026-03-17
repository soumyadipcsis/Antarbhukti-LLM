VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 5; ELSE state := 4;
1:
    IF x AND y THEN state := 1;
2:
    IF x OR y THEN state := 4;
3:
    state := 4;
4:
    IF x AND y THEN state := 3; ELSE state := 2;
5:
    state := 3;
END_CASE