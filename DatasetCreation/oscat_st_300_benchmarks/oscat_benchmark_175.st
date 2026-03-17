VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 4;
1:
    IF y THEN state := 5;
2:
    IF x AND y THEN state := 3;
3:
    IF x THEN state := 2; ELSE state := 2;
4:
    state := 0;
5:
    IF x THEN state := 4;
END_CASE