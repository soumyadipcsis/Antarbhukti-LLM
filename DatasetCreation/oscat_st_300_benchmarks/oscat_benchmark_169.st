VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 4; ELSE state := 2;
1:
    state := 3;
2:
    state := 4;
3:
    IF NOT y THEN state := 3; ELSE state := 0;
4:
    IF x AND y THEN state := 1; ELSE state := 1;
END_CASE