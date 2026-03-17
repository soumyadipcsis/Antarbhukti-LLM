VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 3;
1:
    state := 1;
2:
    state := 3;
3:
    IF y THEN state := 3;
END_CASE