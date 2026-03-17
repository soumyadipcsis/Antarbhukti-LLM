VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1; ELSE state := 1;
1:
    IF NOT y THEN state := 0;
END_CASE