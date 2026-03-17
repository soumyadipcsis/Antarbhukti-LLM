VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    IF x THEN state := 2;
2:
    state := 3;
3:
    IF NOT x THEN state := 1;
4:
    IF x OR y THEN state := 1;
END_CASE