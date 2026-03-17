VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1; ELSE state := 1;
1:
    IF x THEN state := 4; ELSE state := 1;
2:
    state := 4;
3:
    IF NOT y THEN state := 2;
4:
    IF x OR y THEN state := 4; ELSE state := 3;
5:
    state := 5;
END_CASE