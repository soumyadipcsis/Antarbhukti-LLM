VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 3; ELSE state := 5;
1:
    IF x THEN state := 4; ELSE state := 2;
2:
    IF x OR y THEN state := 5;
3:
    IF x OR y THEN state := 3;
4:
    state := 1;
5:
    IF NOT x THEN state := 3; ELSE state := 4;
END_CASE