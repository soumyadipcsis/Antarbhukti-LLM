VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    IF x THEN state := 0; ELSE state := 3;
2:
    IF x OR y THEN state := 1; ELSE state := 1;
3:
    state := 3;
END_CASE