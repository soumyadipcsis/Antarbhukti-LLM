VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 2; ELSE state := 0;
1:
    state := 2;
2:
    state := 0;
3:
    IF NOT y THEN state := 2;
END_CASE