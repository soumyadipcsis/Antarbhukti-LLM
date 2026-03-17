VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    state := 0;
2:
    IF y THEN state := 3; ELSE state := 3;
3:
    state := 3;
4:
    IF NOT y THEN state := 2;
END_CASE