VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 0;
1:
    state := 4;
2:
    state := 2;
3:
    state := 0;
4:
    IF x THEN state := 4; ELSE state := 4;
END_CASE