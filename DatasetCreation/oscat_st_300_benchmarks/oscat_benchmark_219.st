VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 4;
1:
    IF NOT x THEN state := 3; ELSE state := 1;
2:
    IF x OR y THEN state := 1;
3:
    state := 5;
4:
    state := 0;
5:
    state := 3;
END_CASE