VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF y THEN state := 1;
1:
    IF NOT y THEN state := 1;
2:
    state := 2;
3:
    IF x OR y THEN state := 1;
END_CASE