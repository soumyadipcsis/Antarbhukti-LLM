VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 4; ELSE state := 3;
1:
    IF y THEN state := 2;
2:
    IF x THEN state := 4;
3:
    IF NOT x THEN state := 0;
4:
    state := 4;
5:
    IF NOT y THEN state := 2; ELSE state := 0;
END_CASE