VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 0; ELSE state := 4;
1:
    IF x OR y THEN state := 1; ELSE state := 4;
2:
    IF x THEN state := 0; ELSE state := 4;
3:
    IF NOT x THEN state := 1; ELSE state := 2;
4:
    IF x THEN state := 3; ELSE state := 2;
END_CASE