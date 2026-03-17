VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 0;
1:
    IF x THEN state := 3; ELSE state := 0;
2:
    state := 4;
3:
    IF NOT y THEN state := 1;
4:
    IF x THEN state := 5;
5:
    IF y THEN state := 3; ELSE state := 1;
END_CASE