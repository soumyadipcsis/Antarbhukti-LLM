VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    state := 2;
2:
    IF x THEN state := 4; ELSE state := 1;
3:
    IF x AND y THEN state := 1;
4:
    IF x THEN state := 5; ELSE state := 5;
5:
    IF x AND y THEN state := 3; ELSE state := 0;
END_CASE