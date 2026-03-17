VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 5;
1:
    IF y THEN state := 3;
2:
    state := 4;
3:
    IF NOT x THEN state := 1; ELSE state := 1;
4:
    IF y THEN state := 2;
5:
    state := 3;
END_CASE