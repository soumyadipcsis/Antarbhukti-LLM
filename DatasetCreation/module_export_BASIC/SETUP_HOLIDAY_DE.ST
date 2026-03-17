(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: SETUP
*)
(*@KEY@:DESCRIPTION*)

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK SETUP_HOLIDAY_DE

(*Group:Default*)


VAR_IN_OUT
	HD :	oscat_HOLIDAY_DATA_0_29;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_HOLIDAY_DE
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;

init := TRUE;

(* ---- german --- *)

HD[00].NAME := STRING#'Neujahr';
HD[00].DAY  := SINT#01;
HD[00].MONTH := SINT#01;
HD[00].USE := SINT#01;

HD[01].NAME := STRING#'Heilige Drei Koenige';
HD[01].DAY  := SINT#06;
HD[01].MONTH := SINT#01;
HD[01].USE := SINT#01;

HD[02].NAME := STRING#'Karfreitag';
HD[02].DAY  := SINT#-2;
HD[02].MONTH := SINT#00;
HD[02].USE := SINT#01;

HD[03].NAME := STRING#'Ostersonntag';
HD[03].DAY  := SINT#00;
HD[03].MONTH := SINT#00;
HD[03].USE := SINT#01;

HD[04].NAME := STRING#'Ostermontag';
HD[04].DAY  := SINT#01;
HD[04].MONTH := SINT#00;
HD[04].USE := SINT#01;

HD[05].NAME := STRING#'Tag der Arbeit';
HD[05].DAY  := SINT#01;
HD[05].MONTH := SINT#05;
HD[05].USE := SINT#01;

HD[06].NAME := STRING#'Christi Himmelfahrt';
HD[06].DAY  := SINT#39;
HD[06].MONTH := SINT#00;
HD[06].USE := SINT#01;

HD[07].NAME := STRING#'Pfingstsonntag';
HD[07].DAY  := SINT#49;
HD[07].MONTH := SINT#00;
HD[07].USE := SINT#01;

HD[08].NAME := STRING#'Pfingstmontag';
HD[08].DAY  := SINT#50;
HD[08].MONTH := SINT#00;
HD[08].USE := SINT#01;

HD[09].NAME := STRING#'Fronleichnam';
HD[09].DAY  := SINT#60;
HD[09].MONTH := SINT#00;
HD[09].USE := SINT#01;

HD[10].NAME := STRING#'Augsburger Friedensfest';
HD[10].DAY  := SINT#08;
HD[10].MONTH := SINT#08;
HD[10].USE := SINT#00;

HD[11].NAME := STRING#'Maria Himmelfahrt';
HD[11].DAY  := SINT#15;
HD[11].MONTH := SINT#08;
HD[11].USE := SINT#01;

HD[12].NAME := STRING#'Tag der Deutschen Einheit';
HD[12].DAY  := SINT#03;
HD[12].MONTH := SINT#10;
HD[12].USE := SINT#01;

HD[13].NAME := STRING#'Reformationstag';
HD[13].DAY  := SINT#31;
HD[13].MONTH := SINT#10;
HD[13].USE := SINT#00;

HD[14].NAME := STRING#'Allerheiligen';
HD[14].DAY  := SINT#01;
HD[14].MONTH := SINT#11;
HD[14].USE := SINT#01;

HD[15].NAME := STRING#'Buss und Bettag';
HD[15].DAY  := SINT#23;
HD[15].MONTH := SINT#11;
HD[15].USE := SINT#00;

HD[16].NAME := STRING#'1. Weihnachtsfeiertag';
HD[16].DAY  := SINT#25;
HD[16].MONTH := SINT#12;
HD[16].USE := SINT#01;

HD[17].NAME := STRING#'2. Weihnachtsfeiertag';
HD[17].DAY  := SINT#26;
HD[17].MONTH := SINT#12;
HD[17].USE := SINT#01;


(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
