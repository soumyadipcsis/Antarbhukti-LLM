VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 2; ELSE state := 1;
1:
    state := 4;
2:
    state := 5;
3:
    IF y THEN state := 4; ELSE state := 2;
4:
    IF NOT x THEN state := 3;
5:
    IF NOT y THEN state := 3;
END_CASE