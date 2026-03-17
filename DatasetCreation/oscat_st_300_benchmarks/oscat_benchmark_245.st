VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1;
1:
    IF NOT y THEN state := 3;
2:
    IF NOT x THEN state := 1;
3:
    state := 1;
4:
    IF x THEN state := 1;
5:
    state := 4;
END_CASE