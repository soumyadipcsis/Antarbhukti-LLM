VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 1;
1:
    state := 3;
2:
    IF NOT x THEN state := 1;
3:
    IF NOT x THEN state := 5; ELSE state := 2;
4:
    state := 3;
5:
    state := 5;
END_CASE