PROGRAM TANK
VAR state : INT := 0; low : BOOL; high : BOOL; END_VAR

CASE state OF
0: IF low THEN state := 1; END_IF;
1: IF high THEN state := 2; END_IF;
2: state := 3;
3: state := 0;
END_CASE;
END_PROGRAM