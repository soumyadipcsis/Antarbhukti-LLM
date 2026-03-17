VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 4;
1:
    IF NOT x THEN state := 5; ELSE state := 0;
2:
    state := 3;
3:
    IF x THEN state := 5;
4:
    IF NOT x THEN state := 0; ELSE state := 5;
5:
    IF NOT y THEN state := 5; ELSE state := 4;
END_CASE