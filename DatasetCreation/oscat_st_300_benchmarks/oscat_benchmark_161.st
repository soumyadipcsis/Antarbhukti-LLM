VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 1; ELSE state := 1;
1:
    IF x AND y THEN state := 0; ELSE state := 1;
2:
    IF NOT x THEN state := 4; ELSE state := 2;
3:
    IF x OR y THEN state := 4;
4:
    IF NOT y THEN state := 0;
END_CASE