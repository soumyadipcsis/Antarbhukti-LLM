VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 3;
1:
    IF x OR y THEN state := 2;
2:
    IF x AND y THEN state := 3;
3:
    IF NOT x THEN state := 2;
END_CASE