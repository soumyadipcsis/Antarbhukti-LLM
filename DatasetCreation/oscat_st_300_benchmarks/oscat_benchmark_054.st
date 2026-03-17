VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    IF NOT x THEN state := 1;
2:
    IF y THEN state := 2; ELSE state := 0;
END_CASE