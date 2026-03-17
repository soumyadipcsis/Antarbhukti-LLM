VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 5;
1:
    IF x OR y THEN state := 3;
2:
    state := 3;
3:
    IF NOT y THEN state := 1;
4:
    IF x THEN state := 5;
5:
    IF x THEN state := 3; ELSE state := 1;
END_CASE