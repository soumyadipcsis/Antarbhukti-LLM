VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 3; ELSE state := 5;
1:
    IF y THEN state := 0;
2:
    state := 3;
3:
    state := 0;
4:
    state := 5;
5:
    IF y THEN state := 4;
END_CASE