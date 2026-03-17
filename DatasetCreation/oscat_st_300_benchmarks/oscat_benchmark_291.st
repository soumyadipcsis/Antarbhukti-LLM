VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 1;
1:
    state := 3;
2:
    IF x AND y THEN state := 3;
3:
    state := 1;
4:
    IF x THEN state := 2; ELSE state := 4;
END_CASE