VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    IF NOT y THEN state := 2;
2:
    state := 3;
3:
    IF y THEN state := 1; ELSE state := 2;
END_CASE