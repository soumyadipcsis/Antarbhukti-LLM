VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF NOT y THEN state := 0;
2:
    IF x AND y THEN state := 0; ELSE state := 4;
3:
    IF x OR y THEN state := 0; ELSE state := 1;
4:
    IF x THEN state := 0;
END_CASE