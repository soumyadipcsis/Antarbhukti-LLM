VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 0;
1:
    IF x THEN state := 4;
2:
    state := 2;
3:
    IF x THEN state := 3;
4:
    IF y THEN state := 1; ELSE state := 1;
END_CASE