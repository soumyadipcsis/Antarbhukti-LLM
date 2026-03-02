PROGRAM TRAFFIC_LIGHT
VAR state : INT := 0; END_VAR

CASE state OF
0: state := 1;
1: state := 2;
2: state := 3;
3: state := 0;
END_CASE;
END_PROGRAM