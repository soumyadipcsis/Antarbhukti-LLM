VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 0; ELSE state := 2;
1:
    state := 1;
2:
    IF x AND y THEN state := 1;
END_CASE