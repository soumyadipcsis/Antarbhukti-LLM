VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 3;
1:
    IF x OR y THEN state := 2; ELSE state := 3;
2:
    IF NOT x THEN state := 0;
3:
    IF x AND y THEN state := 3; ELSE state := 3;
4:
    IF NOT x THEN state := 2; ELSE state := 5;
5:
    state := 3;
END_CASE