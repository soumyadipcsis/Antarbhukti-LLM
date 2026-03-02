PROGRAM ELEVATOR
VAR state : INT := 0; call_up : BOOL; call_down : BOOL; END_VAR

CASE state OF
0: IF call_up THEN state := 1; END_IF;
1: state := 2;
2: state := 3;
3: IF call_down THEN state := 4; END_IF;
4: state := 0;
END_CASE;
END_PROGRAM