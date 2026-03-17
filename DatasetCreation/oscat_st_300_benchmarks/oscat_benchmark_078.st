VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 5;
1:
    IF x THEN state := 1; ELSE state := 2;
2:
    IF NOT y THEN state := 2;
3:
    state := 3;
4:
    IF NOT x THEN state := 0;
5:
    IF NOT x THEN state := 1; ELSE state := 1;
END_CASE