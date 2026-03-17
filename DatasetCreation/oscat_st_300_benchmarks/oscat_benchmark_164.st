VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    IF y THEN state := 4; ELSE state := 1;
2:
    state := 0;
3:
    state := 2;
4:
    IF x THEN state := 4; ELSE state := 2;
END_CASE