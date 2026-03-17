VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 0; ELSE state := 2;
1:
    state := 3;
2:
    state := 2;
3:
    state := 3;
4:
    IF x THEN state := 0;
END_CASE