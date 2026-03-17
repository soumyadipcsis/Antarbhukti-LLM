PROGRAM PICK_PLACE
VAR state : INT := 0; part_ready : BOOL; END_VAR

CASE state OF
0: IF part_ready THEN state := 1; END_IF;
1: state := 2;
2: state := 3;
3: state := 4;
4: state := 5;
5: state := 0;
END_CASE;
END_PROGRAM