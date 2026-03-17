VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x THEN state := 3;
1:
    IF x THEN state := 1;
2:
    IF y THEN state := 0;
3:
    IF NOT x THEN state := 3;
END_CASE