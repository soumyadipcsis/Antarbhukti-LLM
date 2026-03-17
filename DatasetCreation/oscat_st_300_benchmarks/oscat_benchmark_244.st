VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 1;
1:
    IF x THEN state := 3; ELSE state := 1;
2:
    IF NOT y THEN state := 2; ELSE state := 1;
3:
    IF y THEN state := 3; ELSE state := 0;
4:
    IF x AND y THEN state := 3; ELSE state := 3;
END_CASE