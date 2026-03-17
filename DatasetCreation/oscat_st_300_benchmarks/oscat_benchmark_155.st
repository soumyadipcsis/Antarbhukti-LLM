VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 3;
1:
    IF x THEN state := 0;
2:
    state := 2;
3:
    IF x OR y THEN state := 0; ELSE state := 3;
END_CASE