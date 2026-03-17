VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    IF x AND y THEN state := 2;
2:
    IF NOT x THEN state := 0; ELSE state := 0;
END_CASE