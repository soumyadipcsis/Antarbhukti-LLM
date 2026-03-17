VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 2;
1:
    IF x OR y THEN state := 0;
2:
    IF x OR y THEN state := 2;
3:
    IF x AND y THEN state := 0; ELSE state := 3;
END_CASE