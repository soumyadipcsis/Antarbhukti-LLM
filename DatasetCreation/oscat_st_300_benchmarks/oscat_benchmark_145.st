VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 5;
1:
    IF x THEN state := 2; ELSE state := 5;
2:
    state := 0;
3:
    IF x THEN state := 3; ELSE state := 5;
4:
    IF NOT y THEN state := 1;
5:
    IF NOT y THEN state := 2; ELSE state := 1;
END_CASE