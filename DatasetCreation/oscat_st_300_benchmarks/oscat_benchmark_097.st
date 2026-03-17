VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 0; ELSE state := 1;
1:
    IF y THEN state := 0;
2:
    IF NOT x THEN state := 2;
END_CASE