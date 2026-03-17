VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 2;
1:
    state := 2;
2:
    IF y THEN state := 0; ELSE state := 1;
END_CASE