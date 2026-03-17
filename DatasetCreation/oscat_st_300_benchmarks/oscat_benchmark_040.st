VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 2; ELSE state := 1;
1:
    state := 3;
2:
    IF x AND y THEN state := 4; ELSE state := 4;
3:
    state := 0;
4:
    IF x AND y THEN state := 0; ELSE state := 3;
END_CASE