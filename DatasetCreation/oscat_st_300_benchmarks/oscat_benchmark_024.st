VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 2;
1:
    IF x OR y THEN state := 4; ELSE state := 4;
2:
    IF x OR y THEN state := 3; ELSE state := 1;
3:
    IF x THEN state := 4;
4:
    state := 3;
END_CASE