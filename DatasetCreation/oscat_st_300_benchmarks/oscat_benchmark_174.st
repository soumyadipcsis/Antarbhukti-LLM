VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF x AND y THEN state := 4; ELSE state := 1;
2:
    IF NOT y THEN state := 4;
3:
    IF NOT x THEN state := 1; ELSE state := 2;
4:
    state := 4;
5:
    IF NOT x THEN state := 0;
END_CASE