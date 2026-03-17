VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 2; ELSE state := 1;
1:
    IF x AND y THEN state := 1; ELSE state := 2;
2:
    state := 2;
END_CASE