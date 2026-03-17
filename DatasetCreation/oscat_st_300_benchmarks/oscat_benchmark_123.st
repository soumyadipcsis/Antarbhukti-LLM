VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 4;
1:
    IF x AND y THEN state := 3; ELSE state := 1;
2:
    IF x THEN state := 0; ELSE state := 3;
3:
    IF NOT x THEN state := 3; ELSE state := 1;
4:
    IF NOT y THEN state := 0; ELSE state := 0;
END_CASE