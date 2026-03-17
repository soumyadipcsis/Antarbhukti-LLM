VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 0; ELSE state := 1;
1:
    state := 2;
2:
    state := 3;
3:
    IF NOT y THEN state := 1; ELSE state := 3;
END_CASE