VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    state := 2;
2:
    IF y THEN state := 2;
END_CASE