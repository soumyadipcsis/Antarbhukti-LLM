VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    state := 0;
2:
    state := 0;
3:
    state := 1;
4:
    IF x AND y THEN state := 3; ELSE state := 2;
END_CASE