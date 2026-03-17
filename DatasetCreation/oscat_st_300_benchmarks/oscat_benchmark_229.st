VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 3; ELSE state := 5;
1:
    state := 3;
2:
    state := 5;
3:
    state := 0;
4:
    IF NOT y THEN state := 5;
5:
    state := 0;
END_CASE