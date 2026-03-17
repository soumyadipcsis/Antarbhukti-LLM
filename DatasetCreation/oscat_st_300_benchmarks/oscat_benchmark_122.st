VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT y THEN state := 2;
1:
    IF x AND y THEN state := 5;
2:
    IF x OR y THEN state := 5;
3:
    IF x THEN state := 0;
4:
    IF x THEN state := 3;
5:
    IF y THEN state := 3;
END_CASE