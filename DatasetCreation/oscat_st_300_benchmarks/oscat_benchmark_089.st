VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 0; ELSE state := 3;
1:
    state := 3;
2:
    IF NOT x THEN state := 2; ELSE state := 4;
3:
    state := 3;
4:
    state := 5;
5:
    state := 1;
END_CASE