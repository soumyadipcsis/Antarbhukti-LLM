VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 4;
1:
    IF y THEN state := 0; ELSE state := 5;
2:
    IF x THEN state := 5;
3:
    state := 0;
4:
    IF x AND y THEN state := 0; ELSE state := 1;
5:
    IF NOT y THEN state := 3;
END_CASE