/*
supported languages:

af : Afrikaans
sq : Albanian
hy : Armenian
cn : Chinese
hr : Croatian
cs : Czech
da : Danish
nl : Dutch
en : English
fi : Finnish
fr : French
ka : Georgian
de : German
el : Greek
ht : Haitian Creole
hi : Hindi
hu : Hungarian
is : Icelandic
id : Indonesian
it : Italian
ja : Japanese
ko : Korean
la : Latin
lv : Latvian
lt : Lithuanian
mk : Macedonian
no : Norwegian
pl : Polish
pt : Portuguese
ro : Romanian
ru : Russian
sr : Serbian
sk : Slovak
es : Spanish
sw : Swahili
sv : Swedish
tr : Turkish
uk : Ukrainian
vi : Vietnamese
cy : Welsh
*/

gTTS_Play(String="",lang="en", volume=100){

global tts_Thread
langs := "AF SQ HY CN DA DE EN FI FR EL " _
. "EL HT HI ID IS IT JA CA KO HR LA " _
. "LV LT MK NL NO PL PT RO RU SV SR " _
. "SK ES SW CS TR UK HU VI CY"

String := umlconv(CheckString(String))

if strlen(String) > 100
{
   msgbox,16,, String too long, a maximum of 100 characters!
   return 0
}
if !instr(langs, lang)
{
   msgbox,16,, Unsupported language!
   return 0
}

volu := volume > 100 ? 100 : volume / 100
tts_Thread := ComObjCreate("WMPlayer.OCX")
tts_Thread.settings.volume := volume
tts_Thread.url := "http://translate.google.com/translate_tts?q=" . uriEncode(String) . "&tl=" . lang
return 1
}

gTTS_isPlaying(){
Global tts_Thread
return (tts_Thread.status = "Beendet") || (tts_Thread.status = "") ? 0 : 1
}

gTTS_Save(String="",lang="en", Filepath=""){
langs := "AF SQ HY CN DA DE EN FI FR EL " _
. "EL HT HI ID IS IT JA CA KO HR LA " _
. "LV LT MK NL NO PL PT RO RU SV SR " _
. "SK ES SW CS TR UK HU VI CY"
String := umlconv(String)
if strlen(String) > 100
{
   msgbox,16,, String too long, a maximum of 100 characters!
   return 0
}
if !instr(langs, lang)
{
   msgbox,16,, Unsupported language!
   return 0
}
if (Filepath = "")
   Filepath := A_scriptdir . "\tts.mp3"
url := "http://translate.google.com/translate_tts?q=" . uriEncode(String) . "&tl=" . lang
urldownloadtofile, % url, % Filepath, 1
return 1
}

umlconv(String){
String := regexreplace(String, "ä", "ae")
String := regexreplace(String, "ö", "oe")
String := regexreplace(String, "ü", "ue")
String := regexreplace(String, "Ä", "ae")
String := regexreplace(String, "Ö", "oe")
String := regexreplace(String, "Ü", "ue")
String := regexreplace(String, "ß", "ss")
return % String
}

; ty derRaphael  :)
uriEncode(str)
{ ; v 0.3 / (w) 24.06.2008 by derRaphael / zLib-Style release
   b_Format := A_FormatInteger
   data := ""
   SetFormat,Integer,H
   Loop,Parse,str
      if ((Asc(A_LoopField)>0x7f) || (Asc(A_LoopField)<0x30) || (asc(A_LoopField)=0x3d))
         data .= "%" . ((StrLen(c:=SubStr(ASC(A_LoopField),3))<2) ? "0" . c : c)
      Else
         data .= A_LoopField
   SetFormat,Integer,%b_format%
   return data
}
