VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 3; ELSE state := 0;
1:
    IF NOT y THEN state := 0;
2:
    state := 1;
3:
    IF NOT y THEN state := 2;
END_CASE