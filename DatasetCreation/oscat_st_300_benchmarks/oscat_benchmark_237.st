VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1; ELSE state := 4;
1:
    state := 1;
2:
    IF NOT y THEN state := 4;
3:
    IF NOT x THEN state := 0; ELSE state := 3;
4:
    IF x OR y THEN state := 5; ELSE state := 3;
5:
    state := 4;
END_CASE