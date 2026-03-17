VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 0;
1:
    IF x THEN state := 2; ELSE state := 3;
2:
    state := 1;
3:
    IF NOT y THEN state := 2;
4:
    state := 4;
END_CASE