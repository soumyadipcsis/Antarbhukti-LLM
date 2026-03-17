VAR
    state : INT := 0;
    x : BOOL;
    y : BOOL;
END_VAR

CASE state OF
0:
    IF x AND y THEN state := 0; ELSE state := 3;
1:
    IF y THEN state := 3;
2:
    IF x THEN state := 2;
3:
    IF NOT x THEN state := 0; ELSE state := 2;
4:
    IF y THEN state := 0; ELSE state := 0;
5:
    IF y THEN state := 0; ELSE state := 4;
END_CASE