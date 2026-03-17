VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF NOT x THEN state := 5;
1:
    IF x OR y THEN state := 1;
2:
    IF x OR y THEN state := 1;
3:
    IF NOT y THEN state := 0; ELSE state := 1;
4:
    IF y THEN state := 2; ELSE state := 5;
5:
    state := 0;
END_CASE