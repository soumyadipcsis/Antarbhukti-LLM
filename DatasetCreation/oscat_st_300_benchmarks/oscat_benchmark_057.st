VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 3;
1:
    IF NOT x THEN state := 2; ELSE state := 4;
2:
    state := 1;
3:
    IF NOT x THEN state := 4;
4:
    IF y THEN state := 1;
5:
    IF y THEN state := 3;
END_CASE