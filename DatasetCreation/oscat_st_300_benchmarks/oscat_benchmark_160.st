VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 4;
1:
    IF x AND y THEN state := 3; ELSE state := 2;
2:
    state := 4;
3:
    IF NOT y THEN state := 1;
4:
    IF y THEN state := 4;
5:
    IF NOT y THEN state := 2; ELSE state := 1;
END_CASE