PROGRAM MODE_MANAGER
VAR state : INT := 0; auto : BOOL; fault : BOOL; END_VAR

CASE state OF
0: IF auto THEN state := 1; END_IF;
1: IF fault THEN state := 3; END_IF;
3: state := 2;
2: state := 0;
END_CASE;
END_PROGRAM