VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 4;
1:
    IF y THEN state := 1; ELSE state := 3;
2:
    IF y THEN state := 2; ELSE state := 3;
3:
    IF y THEN state := 0; ELSE state := 4;
4:
    IF NOT y THEN state := 0; ELSE state := 0;
END_CASE