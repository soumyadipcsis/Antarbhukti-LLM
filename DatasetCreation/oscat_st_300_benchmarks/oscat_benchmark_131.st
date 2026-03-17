VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF NOT y THEN state := 3; ELSE state := 1;
2:
    IF NOT y THEN state := 0;
3:
    IF x OR y THEN state := 0; ELSE state := 1;
END_CASE