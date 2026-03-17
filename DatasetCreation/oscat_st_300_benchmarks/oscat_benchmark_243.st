VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 2; ELSE state := 0;
1:
    IF y THEN state := 0;
2:
    state := 3;
3:
    state := 3;
END_CASE