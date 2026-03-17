VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 3; ELSE state := 4;
1:
    IF x THEN state := 3;
2:
    IF NOT x THEN state := 1;
3:
    IF NOT y THEN state := 4; ELSE state := 4;
4:
    IF NOT y THEN state := 3; ELSE state := 2;
END_CASE