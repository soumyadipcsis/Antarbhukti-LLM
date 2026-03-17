VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 4;
1:
    IF NOT y THEN state := 2;
2:
    state := 4;
3:
    IF x THEN state := 2;
4:
    IF NOT x THEN state := 4;
END_CASE