VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    IF y THEN state := 3;
2:
    IF NOT y THEN state := 3;
3:
    state := 3;
END_CASE