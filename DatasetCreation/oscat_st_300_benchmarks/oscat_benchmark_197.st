VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 0; ELSE state := 0;
1:
    IF NOT y THEN state := 0;
2:
    IF y THEN state := 1; ELSE state := 2;
END_CASE