VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 4; ELSE state := 3;
1:
    IF x THEN state := 0;
2:
    state := 5;
3:
    state := 5;
4:
    IF NOT y THEN state := 4; ELSE state := 4;
5:
    state := 1;
END_CASE