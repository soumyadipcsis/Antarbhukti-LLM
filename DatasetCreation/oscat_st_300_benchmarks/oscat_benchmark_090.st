VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 0; ELSE state := 1;
1:
    state := 0;
END_CASE