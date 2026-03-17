VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 3; ELSE state := 0;
1:
    state := 0;
2:
    state := 1;
3:
    IF x AND y THEN state := 3; ELSE state := 1;
4:
    IF x OR y THEN state := 3; ELSE state := 0;
END_CASE