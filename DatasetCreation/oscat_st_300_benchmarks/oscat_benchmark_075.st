VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 5; ELSE state := 2;
1:
    IF x THEN state := 2;
2:
    state := 3;
3:
    state := 0;
4:
    IF x THEN state := 4; ELSE state := 1;
5:
    IF NOT x THEN state := 5;
END_CASE