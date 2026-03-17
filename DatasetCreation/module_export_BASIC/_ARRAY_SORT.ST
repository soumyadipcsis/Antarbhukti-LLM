(*@PROPERTIES_EX@
TYPE: POU
LOCALE: 0
IEC_LANGUAGE: ST
PLC_TYPE: independent
PROC_TYPE: independent
GROUP: MATHEMATICAL.ARRAY_FUNCTIONS
*)
(*@KEY@:DESCRIPTION*)
version 2.0	19. jan. 2011
programmer 	Alexander Trikitis
tested by	oscat

this function will sort a given array.
this function will manipulate a given array.
the function will not return anything except true, it will instead manipulate the original array.

(*@KEY@:END_DESCRIPTION*)
FUNCTION_BLOCK _ARRAY_SORT

(*Group:Default*)


VAR_IN_OUT
	PT :	oscat_pt_ARRAY;
END_VAR


VAR_INPUT
	SIZE :	UINT;
END_VAR


VAR_OUTPUT
	_ARRAY_SORT :	BOOL;
END_VAR


VAR
	stack_count :	INT;(*Laufvariable Stack*)
	stack :	oscat_stack_array;(*Stackgröße~ 1,6*Log(n)/log(2)*)
	links :	INT;(*Anfangselement des Arrays*)
	rechts :	INT;(*Endelement des Arrays*)
	pivot :	REAL;(*temporärer Schwellwert für Tauschbedingung*)
	i :	INT;(*Laufvariable1*)
	j :	INT;(*Laufvariable2*)
	ende_innen :	BOOL;(*Ende innere Schleife*)
	ende_aussen :	BOOL;(*Ende äußere Schleife*)
	tmp :	REAL;(*Hilfsvariable zum Tauschen von Werten*)
	x :	INT;
END_VAR


(*@KEY@: WORKSHEET
NAME: _ARRAY_SORT
IEC_LANGUAGE: ST
*)
(* Startwerte zur Arraygröße *)
links := 1;	(* Anfangselement des Arrays *)
rechts := DWORD_TO_INT(SHR(UINT_TO_DWORD(size),2)); (* Endelement des Arrays *)
stack_count := 1; (* Laufvariable Stack *)

WHILE NOT ende_aussen DO (* äußere Schleife *)
	IF links < rechts THEN
		x := DWORD_TO_INT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(rechts)+ _INT_TO_UDINT(links)),1));
		pivot := PT[x]; (* Wert des mittleren Elements als Pivot-Wert *)
		i := links - 1;
		j := rechts + 1;

		(* innere Schleife, teile Feld *)
		ende_innen := FALSE;
		REPEAT

			(* steigende Reihenfolge *)
			REPEAT	i := i+1;	UNTIL (PT[i] >= pivot) OR NOT (i < rechts)	END_REPEAT;
			REPEAT	j := j-1;	UNTIL (PT[j] <= pivot) OR NOT (j > links)	END_REPEAT;

			(*sinkende Reihenfolge *)
			(*REPEAT	i := i+1;	UNTIL (PT^[i] <= pivot) OR NOT (i < rechts)	END_REPEAT	*)
			(*REPEAT	j := j-1;	UNTIL (PT^[j] >= pivot) OR NOT (j > links)	END_REPEAT	*)

			IF i >= j THEN
				ende_innen := TRUE;
			ELSE
			    tmp := PT[j];
				PT[j] := PT[i];
				PT[i] := tmp;
			END_IF;

		UNTIL ende_innen END_REPEAT;

		(* Push stack *)
		stack[stack_count] := rechts;		(* rechten Teil später sortieren *)
		IF Stack_count < 32 THEN
			stack_count := stack_count +1;
		ELSE
			ende_aussen := TRUE;
			_ARRAY_SORT := FALSE;					(* Fehler: Stack zu klein *)
		END_IF;

		(* linken Teil sortiern *)
		rechts := MAX(links, i-1);

	ELSE
		IF stack_count = 1 THEN
			ende_aussen := TRUE;
		ELSE

			links := rechts+1;

			(* pop stack *)
			stack_count := stack_count - 1;		(* jetzt rechten Teil sortierne *)
			rechts:= stack[stack_count];
		END_IF;

	END_IF;

END_WHILE;

_ARRAY_SORT := TRUE;				(* Sortierung beendet *)


(* algorithm used before rev 2.0

size := SHR(size,2);
size2 := UINT_TO_INT(SHR(size,1));
FOR i := SIZE2  TO 1 BY -1 DO
	j:=i;
    WHILE j <= SIZE2 DO
     	stop := j * 2 + 1;
        IF stop > UINT_TO_INT(SIZE) THEN stop := stop - 1;
        ELSIF pt^[stop-1] > pt^[stop] THEN stop := stop - 1;
		END_IF;
        IF pt^[j] < pt^[stop] THEN
         	temp := pt^[j];
            pt^[j] := pt^[stop];
            pt^[stop] := temp;
        END_IF;
        j := stop;
    END_WHILE;
END_FOR;

*)

(* heapsort
FOR heapsize := UINT_TO_INT(size) TO 1 BY -1 DO
	popmax := pt^[1];
	pt^[1] := pt^[heapsize];
   	i := 1;
	hs2 := SHR(heapsize,1);
	WHILE i <= hs2 DO
       	stop := i * 2 + 1;  
        	IF stop > heapsize THEN stop := stop - 1;
        	ELSIF pt^[stop-1] > pt^[stop] THEN stop := stop - 1;
	 	END_IF;
        	IF pt^[i] < pt^[stop] THEN
            		temp := pt^[i];
            		pt^[i] := pt^[stop];
            		pt^[stop] := temp;
        	END_IF;
        	i := stop;
    	END_WHILE;
	pt^[heapsize] := popmax;
END_FOR;

_ARRAY_SORT2 := TRUE;
*)

(* old algorithm bubble sort used before rev 1.2
stop := (size - SIZEOF(pt)) / SIZEOF(pt);
FOR i := 0 TO stop - 1 DO
	FOR m := i + 1 TO stop DO
		IF pt^[i] > pt^[m] THEN
			temp := pt^[i];
			pt^[i] := pt^[m];
			pt^[m] := temp;
		END_IF;
	END_FOR;
END_FOR;
_array_sort := TRUE;

*)


(* revision history

hm 	6.1.2007 	rev 1.1
	changed return value to true

hm	22. sep 2007	rev 1.2
	changed sorting algorithm to heap sort for performance reasons

hm 	14. nov 2007	rev 1.3
	changed calculation of stop to be more efficient

hm	15 dec 2007	rev 1.4
	added function return true

hm	5. jan 2008		rev 1.5
	improved performance

hm	16. mar. 2008	rev 1.6
	changed type of input size to uint

hm	28. mar. 2008	rev 1.7
	changed input f to pt

hm	19. jan. 2011	rev 2.0
	new faster algorithm using qucksort (Alexander Drikitis)

*)

(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
