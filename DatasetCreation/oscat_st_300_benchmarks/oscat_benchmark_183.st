VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 1; ELSE state := 4;
1:
    state := 5;
2:
    state := 2;
3:
    state := 1;
4:
    IF x THEN state := 2;
5:
    IF x OR y THEN state := 1; ELSE state := 2;
END_CASE