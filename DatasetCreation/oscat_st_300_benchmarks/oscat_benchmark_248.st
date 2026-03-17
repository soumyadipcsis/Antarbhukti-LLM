VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    state := 2;
2:
    IF x THEN state := 4; ELSE state := 3;
3:
    state := 4;
4:
    IF NOT x THEN state := 2;
END_CASE