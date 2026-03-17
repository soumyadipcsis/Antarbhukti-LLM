VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 0; ELSE state := 3;
1:
    state := 0;
2:
    IF NOT x THEN state := 0; ELSE state := 2;
3:
    state := 1;
END_CASE