VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 4;
1:
    state := 3;
2:
    IF x THEN state := 2; ELSE state := 4;
3:
    state := 2;
4:
    IF y THEN state := 1;
END_CASE