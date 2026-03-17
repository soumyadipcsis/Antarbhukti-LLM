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
FUNCTION_BLOCK SETUP_HOLIDAY_FR

(*Group:Default*)


VAR_IN_OUT
	HD :	oscat_HOLIDAY_DATA_0_29;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_HOLIDAY_FR
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;

init := TRUE;

(* ---- france --- *)

HD[00].NAME := STRING#'Nouvel an';
HD[00].DAY  := SINT#01;
HD[00].MONTH := SINT#01;
HD[00].USE := SINT#01;

HD[01].NAME := STRING#'St Valentin';
HD[01].DAY  := SINT#14;
HD[01].MONTH := SINT#02;
HD[01].USE := SINT#00;

HD[02].NAME := STRING#'Vendredi Saint (alsace)';
HD[02].DAY  := SINT#-2;
HD[02].MONTH := SINT#00;
HD[02].USE := SINT#00;

HD[03].NAME := STRING#'Dimanche de pâques';
HD[03].DAY  := SINT#00;
HD[03].MONTH := SINT#00;
HD[03].USE := SINT#01;

HD[04].NAME := STRING#'Lundi de pâques';
HD[04].DAY  := SINT#01;
HD[04].MONTH := SINT#00;
HD[04].USE := SINT#01;

HD[05].NAME := STRING#'Jeudi de Ascension';
HD[05].DAY  := SINT#39;
HD[05].MONTH := SINT#00;
HD[05].USE := SINT#01;

HD[06].NAME := STRING#'dimanche de Pentecôte';
HD[06].DAY  := SINT#49;
HD[06].MONTH := SINT#00;
HD[06].USE := SINT#01;

HD[07].NAME := STRING#'jeudi de la Trinité';
HD[07].DAY  := SINT#60;
HD[07].MONTH := SINT#00;
HD[07].USE := SINT#00;

HD[08].NAME := STRING#'Fête du travail';
HD[08].DAY  := SINT#01;
HD[08].MONTH := SINT#05;
HD[08].USE := SINT#01;

HD[09].NAME := STRING#'Victoire 1945 ';
HD[09].DAY  := SINT#08;
HD[09].MONTH := SINT#05;
HD[09].USE := SINT#01;

HD[10].NAME := STRING#'Prise de La bastille';
HD[10].DAY  := SINT#14;
HD[10].MONTH := SINT#07;
HD[10].USE := SINT#01;

HD[11].NAME := STRING#'15 Août 1944';
HD[11].DAY  := SINT#15;
HD[11].MONTH := SINT#08;
HD[11].USE := SINT#01;

HD[12].NAME := STRING#'Halloween';
HD[12].DAY  := SINT#31;
HD[12].MONTH := SINT#10;
HD[12].USE := SINT#00;

HD[13].NAME := STRING#'Armistice 1918';
HD[13].DAY  := SINT#11;
HD[13].MONTH := SINT#11;
HD[13].USE := SINT#01;

HD[14].NAME := STRING#'Noël';
HD[14].DAY  := SINT#25;
HD[14].MONTH := SINT#12;
HD[14].USE := SINT#01;

HD[15].NAME := STRING#'Saint Étienne (alsace)';
HD[15].DAY  := SINT#26;
HD[15].MONTH := SINT#12;
HD[15].USE := SINT#00;

HD[16].NAME := STRING#'Fête de la musique';
HD[16].DAY  := SINT#21;
HD[16].MONTH := SINT#06;
HD[16].USE := SINT#00;
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
