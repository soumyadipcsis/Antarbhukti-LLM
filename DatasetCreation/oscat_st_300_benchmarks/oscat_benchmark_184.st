VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF x THEN state := 1; ELSE state := 4;
2:
    IF NOT y THEN state := 4;
3:
    state := 2;
4:
    state := 1;
5:
    state := 4;
END_CASE