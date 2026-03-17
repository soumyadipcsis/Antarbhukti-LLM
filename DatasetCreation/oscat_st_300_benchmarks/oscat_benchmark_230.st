VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 5;
1:
    IF x OR y THEN state := 2;
2:
    state := 3;
3:
    state := 3;
4:
    IF x OR y THEN state := 4; ELSE state := 4;
5:
    state := 2;
END_CASE