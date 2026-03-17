VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 4;
1:
    state := 0;
2:
    IF x THEN state := 5;
3:
    IF x OR y THEN state := 5; ELSE state := 2;
4:
    IF NOT y THEN state := 4;
5:
    IF y THEN state := 0;
END_CASE