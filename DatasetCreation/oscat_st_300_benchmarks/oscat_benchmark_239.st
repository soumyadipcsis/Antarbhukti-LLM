VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x OR y THEN state := 1; ELSE state := 1;
1:
    IF y THEN state := 2; ELSE state := 1;
2:
    state := 3;
3:
    IF x THEN state := 3; ELSE state := 3;
4:
    IF x OR y THEN state := 1; ELSE state := 0;
END_CASE