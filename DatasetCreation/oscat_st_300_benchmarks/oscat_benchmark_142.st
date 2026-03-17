VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 0; ELSE state := 2;
1:
    IF NOT x THEN state := 2; ELSE state := 1;
2:
    IF y THEN state := 0; ELSE state := 2;
END_CASE