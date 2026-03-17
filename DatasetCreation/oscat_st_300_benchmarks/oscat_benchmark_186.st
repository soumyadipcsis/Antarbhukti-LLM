VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    state := 5;
2:
    IF NOT x THEN state := 3; ELSE state := 0;
3:
    IF NOT x THEN state := 1;
4:
    state := 2;
5:
    IF x AND y THEN state := 1;
END_CASE