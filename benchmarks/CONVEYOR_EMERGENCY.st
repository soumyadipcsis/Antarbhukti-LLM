PROGRAM CONVEYOR
VAR state : INT := 0; start : BOOL; emergency : BOOL; END_VAR

CASE state OF
0: IF start THEN state := 1; END_IF;
1: IF emergency THEN state := 3 ELSE state := 2; END_IF;
2: IF emergency THEN state := 3; END_IF;
3: state := 0;
END_CASE;
END_PROGRAM