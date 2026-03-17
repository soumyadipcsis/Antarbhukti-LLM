VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 5;
1:
    state := 4;
2:
    IF NOT x THEN state := 0; ELSE state := 5;
3:
    IF x OR y THEN state := 0; ELSE state := 2;
4:
    state := 2;
5:
    IF x OR y THEN state := 2; ELSE state := 5;
END_CASE