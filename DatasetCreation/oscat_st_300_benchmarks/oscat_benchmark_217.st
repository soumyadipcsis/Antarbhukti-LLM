VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 2; ELSE state := 1;
1:
    state := 2;
2:
    IF NOT y THEN state := 0; ELSE state := 2;
END_CASE