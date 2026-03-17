VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    state := 4;
1:
    IF y THEN state := 1; ELSE state := 4;
2:
    IF y THEN state := 2; ELSE state := 0;
3:
    IF x THEN state := 5; ELSE state := 4;
4:
    IF y THEN state := 5;
5:
    IF y THEN state := 4; ELSE state := 3;
END_CASE