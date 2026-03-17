VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 5; ELSE state := 1;
1:
    IF x AND y THEN state := 5;
2:
    state := 1;
3:
    IF x THEN state := 0; ELSE state := 0;
4:
    IF y THEN state := 4;
5:
    IF x THEN state := 4; ELSE state := 4;
END_CASE