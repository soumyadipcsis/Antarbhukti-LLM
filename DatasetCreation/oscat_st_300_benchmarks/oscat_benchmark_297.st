VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 1; ELSE state := 2;
1:
    IF y THEN state := 3; ELSE state := 0;
2:
    IF x AND y THEN state := 3; ELSE state := 0;
3:
    IF y THEN state := 1;
END_CASE