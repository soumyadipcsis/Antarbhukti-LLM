VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    state := 1;
2:
    state := 1;
3:
    state := 0;
4:
    IF NOT x THEN state := 3; ELSE state := 4;
END_CASE