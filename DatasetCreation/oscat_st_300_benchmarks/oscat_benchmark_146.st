VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 0;
1:
    IF NOT x THEN state := 0;
2:
    IF x AND y THEN state := 0;
3:
    IF x AND y THEN state := 4;
4:
    IF x AND y THEN state := 0;
END_CASE