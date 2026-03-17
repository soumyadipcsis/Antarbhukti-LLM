VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 3;
1:
    IF NOT x THEN state := 4;
2:
    IF NOT y THEN state := 2; ELSE state := 2;
3:
    IF y THEN state := 0; ELSE state := 4;
4:
    IF y THEN state := 1; ELSE state := 4;
END_CASE