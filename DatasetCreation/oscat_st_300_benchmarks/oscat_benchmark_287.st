VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    state := 2;
2:
    IF x AND y THEN state := 0; ELSE state := 0;
3:
    IF NOT y THEN state := 3;
END_CASE