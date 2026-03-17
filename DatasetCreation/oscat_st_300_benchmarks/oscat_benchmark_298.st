VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 4; ELSE state := 4;
1:
    IF NOT y THEN state := 1;
2:
    IF y THEN state := 3; ELSE state := 1;
3:
    IF NOT x THEN state := 0; ELSE state := 2;
4:
    state := 1;
5:
    IF NOT y THEN state := 2;
END_CASE