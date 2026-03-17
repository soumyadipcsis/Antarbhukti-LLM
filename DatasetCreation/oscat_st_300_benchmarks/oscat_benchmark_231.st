VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1;
1:
    IF NOT y THEN state := 5; ELSE state := 3;
2:
    IF NOT y THEN state := 0; ELSE state := 0;
3:
    IF x OR y THEN state := 5;
4:
    IF x THEN state := 2; ELSE state := 5;
5:
    state := 3;
END_CASE