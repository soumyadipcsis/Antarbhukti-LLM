VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 3;
1:
    state := 0;
2:
    IF y THEN state := 1;
3:
    IF x AND y THEN state := 0; ELSE state := 0;
4:
    IF x THEN state := 2; ELSE state := 0;
END_CASE