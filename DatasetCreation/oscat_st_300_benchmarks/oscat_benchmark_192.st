VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    state := 1;
2:
    IF x THEN state := 2;
3:
    state := 0;
4:
    IF x THEN state := 1;
5:
    IF NOT x THEN state := 1;
END_CASE