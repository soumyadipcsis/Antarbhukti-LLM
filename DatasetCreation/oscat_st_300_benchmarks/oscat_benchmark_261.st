VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 4; ELSE state := 4;
1:
    state := 1;
2:
    IF NOT x THEN state := 0;
3:
    state := 3;
4:
    IF x OR y THEN state := 1;
END_CASE