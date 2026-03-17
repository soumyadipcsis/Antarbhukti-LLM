VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 3; ELSE state := 0;
1:
    IF y THEN state := 3;
2:
    state := 1;
3:
    IF NOT x THEN state := 4;
4:
    IF x OR y THEN state := 2; ELSE state := 4;
END_CASE