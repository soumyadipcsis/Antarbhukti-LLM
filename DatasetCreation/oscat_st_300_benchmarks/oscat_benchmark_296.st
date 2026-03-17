VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 0;
1:
    IF x THEN state := 1; ELSE state := 2;
2:
    state := 0;
3:
    IF x OR y THEN state := 2;
4:
    state := 4;
5:
    IF y THEN state := 4;
END_CASE