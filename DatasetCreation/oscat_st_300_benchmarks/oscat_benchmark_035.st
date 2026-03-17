VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 5; ELSE state := 3;
1:
    state := 3;
2:
    IF x THEN state := 2; ELSE state := 5;
3:
    IF x AND y THEN state := 2; ELSE state := 2;
4:
    state := 0;
5:
    state := 3;
END_CASE