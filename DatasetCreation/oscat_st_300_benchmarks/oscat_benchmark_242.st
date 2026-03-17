VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 0;
1:
    IF x OR y THEN state := 1;
END_CASE