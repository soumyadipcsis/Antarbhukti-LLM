VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    state := 1;
2:
    IF NOT y THEN state := 2; ELSE state := 1;
3:
    state := 3;
4:
    IF x AND y THEN state := 3;
END_CASE