VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 4;
1:
    IF NOT y THEN state := 1; ELSE state := 3;
2:
    IF y THEN state := 0; ELSE state := 4;
3:
    IF NOT y THEN state := 0; ELSE state := 3;
4:
    IF x OR y THEN state := 2;
END_CASE