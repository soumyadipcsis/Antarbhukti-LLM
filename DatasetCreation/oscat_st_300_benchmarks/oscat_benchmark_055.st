VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 1;
1:
    IF x OR y THEN state := 3; ELSE state := 2;
2:
    IF x AND y THEN state := 0; ELSE state := 3;
3:
    IF x OR y THEN state := 1; ELSE state := 1;
END_CASE