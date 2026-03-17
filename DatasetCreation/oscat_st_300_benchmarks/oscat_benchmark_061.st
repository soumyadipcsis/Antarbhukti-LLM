VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 0;
1:
    IF NOT y THEN state := 4; ELSE state := 3;
2:
    IF x OR y THEN state := 3; ELSE state := 2;
3:
    IF x THEN state := 1; ELSE state := 1;
4:
    IF x AND y THEN state := 4; ELSE state := 0;
END_CASE