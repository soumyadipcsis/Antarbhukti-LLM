VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    state := 3;
2:
    IF NOT x THEN state := 3;
3:
    IF x AND y THEN state := 3;
4:
    state := 1;
END_CASE