VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 1;
1:
    IF x AND y THEN state := 0;
2:
    IF NOT x THEN state := 0;
3:
    IF x OR y THEN state := 2; ELSE state := 3;
END_CASE