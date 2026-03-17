VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    state := 3;
2:
    state := 2;
3:
    IF y THEN state := 0; ELSE state := 2;
4:
    state := 4;
END_CASE