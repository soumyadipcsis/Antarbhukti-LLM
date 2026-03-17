VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 4;
1:
    IF x AND y THEN state := 1;
2:
    state := 4;
3:
    state := 1;
4:
    IF NOT y THEN state := 4;
5:
    IF NOT x THEN state := 5;
END_CASE