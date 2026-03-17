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
FUNCTION_BLOCK SETUP_CHARNAMES

(*Group:Default*)


VAR_IN_OUT
	CHARNAMES :	oscat_CHARNAMES;
END_VAR


VAR
	init :	BOOL;
END_VAR


(*@KEY@: WORKSHEET
NAME: SETUP_CHARNAMES
IEC_LANGUAGE: ST
*)
(* Daten initialisieren *)
IF init THEN RETURN; END_IF;

init := TRUE;

CHARNAMES[01] := ';"&quot;&&amp;<&lt;>&gt;€&euro; &nbsp;¡&iexcl;¢&cent;£&pound;¤&curren;¥&yen;';
CHARNAMES[02] := ';¦&brvbar;§&sect;¨&uml;©&copy;ª&ordf;«&laquo;¬&not;­&shy;®&reg;¯&macr;°&deg;';
CHARNAMES[03] := ';±&plusmn;²&sup2;³&sup3;´&acute;µ&micro;¶&para;·&middot;¸&cedil;¹&sup1;º&ordm;';
CHARNAMES[04] := ';»&raquo;¼&frac14;½&frac12;¾&frac34;¿&iquest;À&Agrave;Á&Aacute;Â&Acirc;Ã&Atilde;';
CHARNAMES[05] := ';Ä&Auml;Å&Aring;Æ&AElig;Ç&Ccedil;È&Egrave;É&Eacute;Ê&Ecirc;Ë&Euml;Ì&Igrave;';
CHARNAMES[06] := ';Í&Iacute;Î&Icirc;Ï&Iuml;Ð&ETH;Ñ&Ntilde;Ò&Ograve;Ó&Oacute;Ô&Ocirc;Õ&Otilde;';
CHARNAMES[07] := ';Ö&Ouml;×&times;Ø&Oslash;Ù&Ugrave;Ú&Uacute;Û&Ucirc;Ü&Uuml;Ý&Yacute;Þ&THORN;';
CHARNAMES[08] := ';ß&szlig;à&agrave;á&aacute;â&acirc;ã&atilde;ä&auml;å&aring;æ&aelig;ç&ccedil;';
CHARNAMES[09] := ';è&egrave;é&eacute;ê&ecirc;ë&euml;ì&igrave;í&iacute;î&icirc;ï&iuml;ð&eth;';
CHARNAMES[10] := ';ñ&ntilde;ò&ograve;ó&oacute;ô&ocirc;õ&otilde;ö&ouml;÷&divide;ø&oslash;ù&ugrave;';
CHARNAMES[11] := ';ú&uacute;û&ucirc;ü&uuml;ý&yacute;þ&thorn;ÿ&yuml;';
(*@KEY@: END_WORKSHEET *)
END_FUNCTION_BLOCK
