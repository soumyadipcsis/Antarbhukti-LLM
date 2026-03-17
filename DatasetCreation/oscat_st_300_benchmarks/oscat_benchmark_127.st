VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 2;
1:
    IF x OR y THEN state := 2;
2:
    state := 2;
3:
    IF x THEN state := 4; ELSE state := 0;
4:
    state := 0;
END_CASE