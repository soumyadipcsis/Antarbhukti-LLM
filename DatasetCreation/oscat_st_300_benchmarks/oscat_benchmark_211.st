VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 0; ELSE state := 0;
1:
    IF x OR y THEN state := 1;
2:
    IF NOT x THEN state := 0;
3:
    IF x AND y THEN state := 3; ELSE state := 2;
4:
    state := 2;
END_CASE