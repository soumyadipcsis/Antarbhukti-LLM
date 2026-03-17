VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 3; ELSE state := 0;
1:
    IF x OR y THEN state := 4; ELSE state := 4;
2:
    state := 0;
3:
    IF x OR y THEN state := 2; ELSE state := 4;
4:
    state := 0;
END_CASE