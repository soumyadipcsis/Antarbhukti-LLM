VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 2;
1:
    state := 3;
2:
    IF x THEN state := 2; ELSE state := 0;
3:
    IF y THEN state := 1; ELSE state := 0;
4:
    state := 3;
END_CASE