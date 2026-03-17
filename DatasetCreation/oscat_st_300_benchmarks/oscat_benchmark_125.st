VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 5; ELSE state := 0;
1:
    IF x OR y THEN state := 3;
2:
    IF y THEN state := 4;
3:
    IF x AND y THEN state := 5; ELSE state := 4;
4:
    state := 3;
5:
    state := 2;
END_CASE