VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    state := 2;
2:
    IF x THEN state := 4; ELSE state := 0;
3:
    IF NOT x THEN state := 4; ELSE state := 2;
4:
    state := 2;
END_CASE