VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 1; ELSE state := 5;
1:
    IF y THEN state := 1; ELSE state := 0;
2:
    state := 2;
3:
    IF x AND y THEN state := 5; ELSE state := 0;
4:
    IF x AND y THEN state := 0; ELSE state := 3;
5:
    IF NOT y THEN state := 4; ELSE state := 3;
END_CASE