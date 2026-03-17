VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    IF NOT x THEN state := 1;
2:
    IF x AND y THEN state := 4; ELSE state := 2;
3:
    IF x THEN state := 2;
4:
    IF NOT y THEN state := 2; ELSE state := 1;
END_CASE