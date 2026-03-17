VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 1; ELSE state := 0;
1:
    state := 4;
2:
    IF y THEN state := 1;
3:
    state := 1;
4:
    IF x OR y THEN state := 4;
END_CASE