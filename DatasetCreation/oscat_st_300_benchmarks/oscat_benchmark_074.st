VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 0;
1:
    IF x AND y THEN state := 4;
2:
    IF y THEN state := 0; ELSE state := 3;
3:
    IF x AND y THEN state := 2;
4:
    IF x AND y THEN state := 2;
END_CASE