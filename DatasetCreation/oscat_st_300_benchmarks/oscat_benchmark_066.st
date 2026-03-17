VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 3;
1:
    state := 3;
2:
    state := 1;
3:
    IF y THEN state := 5; ELSE state := 1;
4:
    IF x THEN state := 1; ELSE state := 2;
5:
    state := 0;
END_CASE