VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 4;
1:
    IF y THEN state := 1; ELSE state := 4;
2:
    IF NOT y THEN state := 0; ELSE state := 0;
3:
    IF NOT y THEN state := 0;
4:
    state := 1;
END_CASE