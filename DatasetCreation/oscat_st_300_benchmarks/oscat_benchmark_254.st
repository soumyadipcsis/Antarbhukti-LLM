VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 0;
1:
    IF x AND y THEN state := 1;
2:
    state := 5;
3:
    IF y THEN state := 1; ELSE state := 4;
4:
    state := 3;
5:
    IF x OR y THEN state := 5;
END_CASE