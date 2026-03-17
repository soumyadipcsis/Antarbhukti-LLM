VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 4;
1:
    state := 5;
2:
    state := 1;
3:
    IF x OR y THEN state := 2;
4:
    IF NOT x THEN state := 0;
5:
    IF NOT x THEN state := 3; ELSE state := 5;
END_CASE