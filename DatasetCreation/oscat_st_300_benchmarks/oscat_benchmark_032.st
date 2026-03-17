VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    state := 4;
2:
    IF y THEN state := 1;
3:
    state := 1;
4:
    IF NOT x THEN state := 1; ELSE state := 3;
END_CASE