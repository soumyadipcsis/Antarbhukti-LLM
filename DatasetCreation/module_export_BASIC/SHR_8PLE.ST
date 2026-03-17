(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.FF_EDGE_TRIGGERED
*)
(*@KEY@:DESCRIPTION*)
version 1.0	4 aug 2006
programmer 	hugo
tested by	tobias

8 bit shift register with reset and parallel load
the register can shift up or down
it also has a serial input.
the Din input is on Bit0 for up shift and on bit 7 for down shift
the Dout output is on Bit7 for up shift and on bit 0 for down shift
paralle clock is performed clock synchron while a shift is performed first and then the register is reloaded
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SHR_8PLE

(*Group:Default*)


VAR_INPUT
	DIN :	BOOL;
	DLOAD :	BYTE;
	CLK :	BOOL;
	UP :	BOOL := TRUE;
	LOAD :	BOOL;
	RST :	BOOL;
END_VAR


VAR_OUTPUT
	DOUT :	BOOL;
END_VAR


VAR
	edge :	BOOL := TRUE;
	register :	BYTE;
END_VAR


(*@KEY@: WORKSHEET
NAME: SHR_8PLE
IEC_LANGUAGE: ST
*)
(* flankenerkennung clk wird high und edge war high reset ist nicht aktiv und set ist nicht aktiv *)
IF CLK AND edge AND NOT rst THEN
	edge := FALSE;	(* flanke wurde erkannt und weitere flankenerkennung wird verhindert bis edge wieder true ist *)
	(* hier ist der code für das flankenevent *)
	IF UP THEN						(*shift up *)
		register := SHL(register,1);
        register := BIT_LOAD_B(register,Din,0);  (* register.X0 := Din; *)
        Dout     := BIT_OF_DWORD(BYTE_TO_DWORD(register),7);     (* Dout := register.X7; *)
	ELSE						    (* shift down *);
		register := SHR(register,1);
        register := BIT_LOAD_B(register,Din,7);  (* register.X7 := Din; *)
        Dout     := BIT_OF_DWORD(BYTE_TO_DWORD(register),0);     (* Dout := register.X0; *)
	END_IF;
	IF load THEN							(* the byte on Din will be loaded if load = true *)
		register := Dload;
		IF up THEN
            Dout := BIT_OF_DWORD(BYTE_TO_DWORD(register),7); (* register.X7 *)
        ELSE
            Dout := BIT_OF_DWORD(BYTE_TO_DWORD(register),0); (* register.X0 *)
        END_IF;
	END_IF;
END_IF;
IF NOT clk THEN edge := TRUE; END_IF;	(* sobald clk wieder low wird warten auf nächste flanke *)
IF rst THEN									(* wenn reset aktiv dann ausgang rücksetzen *)
	register := BYTE#0;
	Dout := FALSE;
END_IF;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
