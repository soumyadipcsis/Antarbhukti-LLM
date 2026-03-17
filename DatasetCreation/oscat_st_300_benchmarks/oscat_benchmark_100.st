VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 4; ELSE state := 3;
1:
    state := 4;
2:
    state := 3;
3:
    state := 2;
4:
    IF x OR y THEN state := 3;
5:
    IF NOT x THEN state := 2;
END_CASE