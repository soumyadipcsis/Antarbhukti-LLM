VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    IF NOT x THEN state := 1; ELSE state := 0;
2:
    IF NOT x THEN state := 2;
3:
    IF NOT y THEN state := 3;
END_CASE