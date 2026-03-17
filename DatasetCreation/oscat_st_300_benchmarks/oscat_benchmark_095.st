VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 3; ELSE state := 3;
1:
    IF x OR y THEN state := 3; ELSE state := 2;
2:
    IF x AND y THEN state := 2;
3:
    state := 3;
4:
    state := 3;
END_CASE