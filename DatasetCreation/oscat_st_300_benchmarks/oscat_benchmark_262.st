VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF x THEN state := 1; ELSE state := 0;
2:
    state := 0;
END_CASE