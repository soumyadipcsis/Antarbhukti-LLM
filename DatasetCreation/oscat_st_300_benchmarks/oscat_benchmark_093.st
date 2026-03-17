VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 2;
1:
    state := 1;
2:
    IF NOT y THEN state := 3; ELSE state := 2;
3:
    IF y THEN state := 2; ELSE state := 2;
END_CASE