Cpbd_PastePlainText()
{	; Paste the clipboard in plain text format
	MouseGetPos,,, CurrentWindowID
	WinActivate, ahk_id %CurrentWindowID%
	Clipboard := Clipboard
	Send, ^v
}

GetSelection(PlainText=1)
{	; Get the user's selection and converts it to text format
	LastClipboard := ClipboardAll	; Save the previous clipboard
	Clipboard := ""					; Start off empty to allow ClipWait to detect when the text has arrived
	SendInput, ^c					; Simulate the Copy hotkey (Ctrl+C)
	ClipWait, 2, 1					; Wait 2 seconds for the clipboard to contain text
	If ErrorLevel
		Return
	If not PlainText
		Return, ClipboardAll
	Selection := Clipboard			; Put the clipboard in the variable Selection
	Clipboard := LastClipboard		; Restore the previous clipboard
	Return, Selection				; Return the selection
}

SaveSelection()
{	; Save the user's selection in a txt file
	Selection := GetSelection()	; Call the function to get the selection
	If !Selection
		Return
	InputBox, FileName, Save Clipboard:, File name ?,, 250, 115
	If (!FileName || ErrorLevel )
		Return
	If !FileExist(A_ScriptDir "\Tests")
		FileCreateDir, % A_ScriptDir "\Tests"
	Path := A_ScriptDir "\Tests\" FileName
	FileDelete, % Path
	FileAppend, % Selection, % Path
	Return, Path
}

ChangeBrightness(amount=8)
{
 
  Global br
 
  ;if !br ;This may cause a problem!
  if (br = "")
    br := 128
    
  br := br + amount
  If ( br > 256 )
     br := 256
  If ( br < 0 )
     br := 0

  ShowTrayTip("Current brightness level: " . br)
     
  VarSetCapacity(gr, 512*3)
  Loop, 256
  {
     If (nValue:=(br+128)*(A_Index-1))>65535
        nValue:=65535
     NumPut(nValue, gr,      2*(A_Index-1), "Ushort")
     NumPut(nValue, gr,  512+2*(A_Index-1), "Ushort")
     NumPut(nValue, gr, 1024+2*(A_Index-1), "Ushort")
  }
  hDC := DllCall("GetDC", "Uint", 0)
  DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", &gr)
  DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
  
}
    
ShutdownPC(value)
{
  Shutdown, %value%
}

MoveMouseCursor(x=-3200,y=-3200,r=0){
	global
	CoordMode,Mouse,Screen
	SetMouseDelay,-1
	if(x=-3200){
		x:=MG_X
	}
	if(y=-3200){
		y:=MG_Y
	}
	BlockInput,On
	if(r){
		MouseMove,%x%,%y%,0,R
	}else{
		MouseMove,%x%,%y%,0
	}
	BlockInput,Off
}

/*
AddPrefixSuffix(prefix="", suffix="")
{
  Send, ^c
  Clipboard = %prefix%%Clipboard%%suffix%
  Send, ^v
}
*/

#Include, lib-custom\DynExpressions.lib.ahk
EvaluateExp()
{
  Send, ^c
  ExprInit()
  CompiledExpression := ExprCompile(Clipboard)
  MsgBox % Clipboard " =`n" ExprEval(CompiledExpression)
  Clipboard := ExprEval(CompiledExpression)
}

GetPixelColor()
{
  MouseGetPos, MouseX, MouseY
  PixelGetColor, color, %MouseX%, %MouseY%
  Clipboard = %color%
  ShowTrayTip("The color at the current cursor position is "+color)
}


PlaySound(sound)
{
  if sound=""
    sound = %A_WinDir%\Media\Windows Notify.wav
  ;Msgbox, %sound%
  SoundPlay, %sound%
}

SetVolume(value) ;Only for WinXP
{
  SoundSet,%value%,MASTER,VOLUME
}

SpeakTextClip(string, voice, method)
{
  if method=
    method := "SpeakWait"
  Say(CheckString(string), voice, method)
}

CheckString(string)
{
  if (string = 0 or string = "")
  {
    TempClipboard := Clipboard
    Send, ^c 
    sleep 10ms
    string := Clipboard
    Clipboard := TempClipboard
  }
  else if string = 1
  {
    string := Clipboard
  }
  return string  
}

SayTime(voice)
{
   
  Global DefaultVoice
  
  FormatTime, SayHour, %A_Now%, h ; get current hour
  FormatTime, SayMinute, %A_Now%, m ; get current minutes
  FormatTime, SayAMPM, %A_Now%, tt ; get AM/PM

  If(SayMinute>0 && SayMinute<10) ; add the "oh" for minutes 1 through nine
    SayMinute = oh %SayMinute%
  If(SayMinute=0) ; if the current minute is 0, say oh clock instead of zero
    SayMinute = oh clock
  IfInString, SayAMPM, AM ; If AM, say a m instead of ameters
    SayAMPM = a m
  IfInString, SayAMPM, PM ; If PM, say p m instead of pmeters
    SayAMPM = p m

  SayTimeString = The time is %SayHour% %SayMinute% %SayAMPM% ; announce time

  Say(sayTimeString, voice)
  
}