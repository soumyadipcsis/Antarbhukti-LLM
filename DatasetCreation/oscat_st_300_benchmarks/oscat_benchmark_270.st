VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 4;
1:
    IF x OR y THEN state := 0; ELSE state := 3;
2:
    state := 2;
3:
    IF y THEN state := 0;
4:
    IF x THEN state := 2;
END_CASE