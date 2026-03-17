VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF x OR y THEN state := 1; ELSE state := 1;
2:
    IF x OR y THEN state := 3;
3:
    IF x THEN state := 3; ELSE state := 0;
END_CASE