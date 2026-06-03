(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: LOGIC.GENERATORS
*)
(*@KEY@:DESCRIPTION*)
version 1.4	17 sep 2007
programmer 	oscat
tested by		hans

sequence_8 enables run when a low to high transition is present on start.
a low to high transition on start will restart the sequencer at any time while a rst will hold the sequencer in reset while true.
after run is enabled with a rising edge on start the sequencer waits for wait0 on in0 to enable q0 which stays on for delay0.
the next cycle starts with wait1, continues with delay 1 and so on...
if an edge is not detected during the wait period, the sequencer will then display the error number on the status output.
The status numbers are 1 .. 8 for erros in step 0..7.
after the last step that sets q7, the sequencer leaves q7 on for delay7 and then resets to the initial state.
a step output will indicate the current step of the sequencer and will also be present with a fault condition.
after the first output is turened on the sequencer switches from q0 to q1 and so on, at any time there is only one output enabled.
if an input signal is not detected during a wait period, the sequencer will display the error number ( 1 for in0, 2 for in1 .... ).
when an error is present and the config variable stop_on_error is set then the sequencer will stop. otherwise it will continue.
The status output will also display 110 for waiting and 111 sequece running.
(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SEQUENCE_8

(*Group:Default*)


VAR_INPUT
	IN0 :	BOOL := TRUE;
	IN1 :	BOOL := TRUE;
	IN2 :	BOOL := TRUE;
	IN3 :	BOOL := TRUE;
	IN4 :	BOOL := TRUE;
	IN5 :	BOOL := TRUE;
	IN6 :	BOOL := TRUE;
	IN7 :	BOOL := TRUE;
	START :	BOOL;
	RST :	BOOL;
	WAIT0 :	TIME;
	DELAY0 :	TIME;
	WAIT1 :	TIME;
	DELAY1 :	TIME;
	WAIT2 :	TIME;
	DELAY2 :	TIME;
	WAIT3 :	TIME;
	DELAY3 :	TIME;
	WAIT4 :	TIME;
	DELAY4 :	TIME;
	WAIT5 :	TIME;
	DELAY5 :	TIME;
	WAIT6 :	TIME;
	DELAY6 :	TIME;
	WAIT7 :	TIME;
	DELAY7 :	TIME;
	STOP_ON_ERROR :	BOOL;
END_VAR


VAR_OUTPUT
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	Q4 :	BOOL;
	Q5 :	BOOL;
	Q6 :	BOOL;
	Q7 :	BOOL;
	QX :	BOOL;
	RUN :	BOOL;
	STEP :	INT := -1;
	STATUS :	BYTE;
END_VAR


VAR
	last :	TIME;
	edge :	BOOL;
	tx :	TIME;
	init :	BOOL;
	T_PLC_MS :	T_PLC_MS;
END_VAR


(*@KEY@: WORKSHEET
NAME: SEQUENCE_8
IEC_LANGUAGE: ST
*)
(* read sps timer *)
T_PLC_MS();
tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

(* initialize on startup *)
IF NOT init THEN
	last := tx;
	init := TRUE;
	status := BYTE#110;
END_IF;

(* asynchronous reset *)
IF rst THEN
	step := -1;
	Q0 := FALSE;
	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;
	Q4 := FALSE;
	Q5 := FALSE;
	Q6 := FALSE;
	Q7 := FALSE;
	status := BYTE#110;
	run := FALSE;

(* edge on start input restarts the sequencer *)
ELSIF start AND NOT edge THEN
	step := 0;
	last := tx;
	status := BYTE#111;
	Q0 := FALSE;
	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;
	Q4 := FALSE;
	Q5 := FALSE;
	Q6 := FALSE;
	Q7 := FALSE;
	run := TRUE;
END_IF;
edge := start;

(* check if stop on error is necessary *)
IF status > BYTE#0 AND status < BYTE#100 AND stop_on_error THEN RETURN; END_IF;

(* sequence is running *)
IF run AND step = 0 THEN
	IF NOT q0 AND in0 AND tx - last <= wait0 THEN
		Q0 := TRUE;
		last := tx;
	ELSIF NOT q0 AND tx - last > wait0 THEN
		status := BYTE#1;
		run := FALSE;
	ELSIF q0 AND tx - last >= delay0 THEN
		step := 1;
		last := tx;
	END_IF;
END_IF;
IF run AND step = 1 THEN
	IF NOT q1 AND in1 AND tx - last <= wait1 THEN
		Q0 := FALSE;
		Q1 := TRUE;
		last := tx;
	ELSIF NOT q1 AND Tx - last > wait1 THEN
		status := BYTE#2;
		q0 := FALSE;
		run := FALSE;
	ELSIF q1 AND tx - last >= delay1 THEN
		step := 2;
		last := tx;
	END_IF;
END_IF;
IF run AND step = 2 THEN
	IF NOT q2 AND in2 AND tx - last <= wait2 THEN
		Q1 := FALSE;
		Q2 := TRUE;
		last := tx;
	ELSIF NOT q2 AND Tx - last > wait2 THEN
		status := BYTE#3;
		q1 := FALSE;
		run := FALSE;
	ELSIF q2 AND tx - last >= delay2 THEN
		step := 3;
		last := tx;
	END_IF;
END_IF;
IF run AND step = 3 THEN
	IF NOT q3 AND in3 AND tx - last <= wait3 THEN
		Q2 := FALSE;
		Q3 := TRUE;
		last := tx;
	ELSIF NOT q3 AND Tx - last > wait3 THEN
		status := BYTE#4;
		q2 := FALSE;
		run := FALSE;
	ELSIF q3 AND tx - last >= delay3 THEN
		step := 4;
		last := tx;
	END_IF;
END_IF;
IF run AND step = 4 THEN
	IF NOT q4 AND in4 AND tx - last <= wait4 THEN
		Q3 := FALSE;
		Q4 := TRUE;
		last := tx;
	ELSIF NOT q4 AND Tx - last > wait4 THEN
		status := BYTE#5;
		q3 := FALSE;
		run := FALSE;
	ELSIF q4 AND tx - last >= delay4 THEN
		step := 5;
		last := tx;
	END_IF;
END_IF;
IF run AND step = 5 THEN
	IF NOT q5 AND in5 AND tx - last <= wait5 THEN
		Q4 := FALSE;
		Q5 := TRUE;
		last := tx;
	ELSIF NOT q5 AND Tx - last > wait5 THEN
		status := BYTE#6;
		q4 := FALSE;
		run := FALSE;
	ELSIF q5 AND tx - last >= delay5 THEN
		step := 6;
		last := tx;
	END_IF;
END_IF;
IF run AND step = 6 THEN
	IF NOT q6 AND in6 AND tx - last <= wait6 THEN
		Q5 := FALSE;
		Q6 := TRUE;
		last := tx;
	ELSIF NOT q6 AND Tx - last > wait6 THEN
		status := BYTE#7;
		q5 := FALSE;
		run := FALSE;
	ELSIF q6 AND tx - last >= delay6 THEN
		step := 7;
		last := tx;
	END_IF;
END_IF;
IF run AND step = 7 THEN
	IF NOT q7 AND in7 AND tx - last <= wait7 THEN
		Q6 := FALSE;
		Q7 := TRUE;
		last := tx;
	ELSIF NOT q7 AND Tx - last > wait7 THEN
		status := BYTE#8;
		q6 := FALSE;
		run := FALSE;
	ELSIF q7 AND tx - last >= delay7 THEN
		step := -1;
		Q7 := FALSE;
		Run := FALSE;
		status := BYTE#110;
	END_IF;
END_IF;
QX := q0 OR q1 OR q2 OR q3 OR q4 OR q5 OR q6 OR q7;

(*
hm 1.10.06		rev 1.1
	corrected delay logic to be after event and not before
	added any output

hm 1.12.06		rev 1.2
	corrected failure in sequence logic.
	added init at startup to prevent from initial statuss after start.

hm 17.1.2007		rev 1.3
	changed output fault to status for better compatibility with other modules (ESR)
	added stop on error functionality and setup variable
	default for inputs in0..7 is true.
	renames variable state to step

hm	17.sep 2007		rev 1.4
	replaced time() with T_PLC_MS() for compatibility reasons

*)
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
