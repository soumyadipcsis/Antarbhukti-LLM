VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 3;
1:
    state := 2;
2:
    state := 1;
3:
    IF x THEN state := 0; ELSE state := 1;
END_CASE