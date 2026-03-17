VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 1;
1:
    IF x THEN state := 3; ELSE state := 4;
2:
    IF NOT x THEN state := 0;
3:
    state := 0;
4:
    state := 2;
END_CASE