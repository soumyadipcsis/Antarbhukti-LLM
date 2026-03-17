VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    IF x AND y THEN state := 1;
2:
    state := 0;
3:
    IF NOT x THEN state := 2; ELSE state := 1;
END_CASE