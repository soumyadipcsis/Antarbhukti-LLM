VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 2; ELSE state := 4;
1:
    state := 2;
2:
    IF x OR y THEN state := 0; ELSE state := 0;
3:
    state := 2;
4:
    IF y THEN state := 0; ELSE state := 0;
END_CASE