VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    IF x OR y THEN state := 2; ELSE state := 2;
2:
    state := 1;
3:
    IF y THEN state := 1;
END_CASE