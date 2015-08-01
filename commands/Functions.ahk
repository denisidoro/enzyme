#Include, lib-custom\VolumeOSD.lib.ahk
;ChangeVolumeWithOSD(amount)

Win_Minimize()
{
	MouseGetPos,,, WinID
	WinMinimize, ahk_id %WinID%
}

Win_Maximize(){
	MouseGetPos,,, WinID
	WinMaximize, ahk_id %WinID%
}

Win_Close()
{	; Close the whole current window, not the current tab
	MouseGetPos,,, WinID
	WinClose, ahk_id %WinID%
}

SetWinTopMost(action=2)
{
  if action = 0
    WinSet,Topmost,Off
  else if action = 1
    WinSet,Topmost,On
  else if action = 2
    WinSet,Topmost,Toggle
}

Win_AlwaysOnTop(action=2)
{	; Toggle a window between AlwaysOnTop states
	MouseGetPos,,, WinID
	if action = 0
    WinSet, AlwaysOnTop, Off, ahk_id %WinID%
  else if action = 1
    WinSet, AlwaysOnTop, On, ahk_id %WinID%
  else if action = 2 
    WinSet, AlwaysOnTop, Toggle, ahk_id %WinID%
}

SendWinToBottom()
{
  WinSet,Bottom
}

SetWinTransp(value=2, twobutton=1)
{

  if (!value)
  {  
    WinSet, Transparent, 255, A
    WinSet, Transparent, OFF, A
  }
  
  else
  {
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if !curtrans
        curtrans := 255 + value
    newtrans := curtrans - value
    if (newtrans > 255)
      newtrans := twobutton ? 0 : 255
    else if (newtrans < 0)
      newtrans := twobutton ? 255 : 0
    ;ShowTrayTip(curTrans ", " newTrans ", " value ", " twobutton)
    WinSet, Transparent, %newtrans%, A
  }
  
}

Win_GetClass()
{	; Get the class of the current window
	TimeLimit	:= 3
	t1			:= A_TickCount
	While (Seconds<TimeLimit){
		Sleep, 10
		t2		:= A_TickCount
		Seconds	:= ((t2-t1)//1000)
		MouseGetPos,,, CurrentWindowID
		WinGetClass, CurrentWinClass, ahk_id %CurrentWindowID%
		ToolTip, % "Window class (" TimeLimit-Seconds "s) : " CurrentWinClass
	}
	Clipboard := CurrentWinClass
	ToolTip
}

Win_Last()
{	; Activate the last window
	IDs := Win_GetList()
	Pos := 1
	While (Pos := RegExMatch(IDs, "[^,]+", m, Pos+StrLen(m)))
		ID%A_Index% := m
	WinActivate, % "ahk_id" ID2
}

Win_Next()
{	; Activate the last window
	IDs := Win_GetList()
	Pos := 1
	While (Pos := RegExMatch(IDs, "[^,]+", m, Pos+StrLen(m)))
		ID%A_Index% := m
	ID := ID3 ? ID3 : ID2
	WinActivate, % "ahk_id" ID
}

Win_GetList()
{
	DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	WinGet, ID, List
	Loop, % ID
	{
		ID := ID%A_Index%
		WinGetTitle, Title, ahk_id %ID%
		WinGetClass, Class, ahk_id %ID%
		If Title
			If Title not in Program manager,Startup,Démarrer
				If Class not in tooltips_class32
					IDs .= (IDs ? "," : "") ID
	}
	DetectHiddenWindows, % DetectHiddenWindows
	Return, IDs
}

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

; TOGGLES FILE EXTENSIONS
ToggleFileExtensions:
  RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
  If HiddenFiles_Status = 1 
  {
  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
  }
  Else 
  {
  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
  }
  send, {F5}
return
	
  
; TOGGLES HIDDEN FILES
ToggleHiddenFiles:
  RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
  If HiddenFiles_Status = 2 
  {
  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
  }
  Else 
  {
  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
  }
  send, {F5}
return


;Search selected text on search engine
SearchWebsite(url)
{
  if url = g
    url = http://www.google.com/search?q=
  else if url = w
    url = http://en.wikipedia.org/wiki/Special:Search?search=
  Send, ^c
  Sleep 50
  Run, %url%%clipboard%
}

Wait(msec)
{
  Sleep msec
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

CallMsgBox(msg)
{
  MsgBox, %msg%
}

SetVolume(value) ;Only for WinXP
{
  SoundSet,%value%,MASTER,VOLUME
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

KillProcess(name)
{
  if name !=
    process, close, %name%
  else
  {
    WinGetTitle, Title, A
    WinKill, %Title%
  }
}

GetWindowGroup()
{
  output := "This group is: " mgr_GetConditionGroup(true)
  MsgBox %output%
}

PlaySound(sound)
{
  if sound=""
    sound = %A_WinDir%\Media\Windows Notify.wav
  ;Msgbox, %sound%
  SoundPlay, %sound%
}

GetCurrentKeyState:
  status := GetKeyState(A_ThisHotkey, "T")
  status := (status = 1) ? "ON" : "OFF"
  status = You have just pressed %A_ThisHotkey%`nIt's current status is %status%
  ShowTrayTip(status)
  ;SendInput, % "{" A_ThisHotkey "}"
return

ShortenURL(method)
{

  Send, ^c
  longURL = %clipboard%
  
  ;if (!InStr(longURL, "http://"))
  ;  longURL = http://%longURL%
  
  ShowTrayTip("Shortening URL...`n" . longURL)
  
  ; Goo.gl
  
  if method = 2
  {
  
    ;global API_G
    
    API_G = AIzaSyBDqyjONOz2lWr7tsgBZF5ZghJSGYrOolY
    
    http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
    main:="https://www.googleapis.com/urlshortener/v1/url"
    params:="?key=" API_G
    http.open("POST", main . params, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.send("{""longURL"": """ longURL """}")
    RegExMatch(http.ResponseText, """id"": ""(.*?)""", match)
    ToReturn := match1  
  
  }

  ; Bit.ly
  else
  {
  
    ;global user, API
    
    user = enzyme
    API = R_92d568b9dece99af944e489c47b811a0
    
    http := ComObjCreate("WinHttp.WinHttpRequest.5.1"), main := "http://api.bit.ly/v3/shorten?"
    longURL := urlEncode(longURL) ; Need urlEncode function
    post := "format=txt&login=" user "&apiKey=" API "&longURL=" longURL
    http.open("GET", main . post, false)
    http.send()
    ToReturn := RegexReplace(http.ResponseText, "\r?\n?")  
  
  }
  
  ShowTrayTip("")
  Clipboard := ToReturn
  ShowTrayTip("Url shortened and copied to clipboard!`n" . ToReturn)
  
}

CallNirCmd(argument)
{

  AppLocation := "external/nircmd/nircmd.exe"
  
  if !FileExist(AppLocation)
  {
    Msgbox, 4, Enzyme can't do this by itself..., This action needs a third-party software: NirCmd by NirSoft`nYou can download it at http://www.nirsoft.net/utils/nircmd.html`nAfter downloading, extract its files to <Enzyme's directory>/external/nircmd/`nDo you want to be redirected to this site?
    IfMsgBox, Yes
     Run, http://www.nirsoft.net/utils/nircmd.html
    return
  }
  
  Run, %AppLocation% %argument%,, Hide|UseErrorLevel 

}

CallOrzTimer()
{

  AppLocation := "external/orztimer/Orzeszek Timer.exe"
  
  if !FileExist(AppLocation)
  {
    Msgbox, 4, Enzyme can't do this by itself..., This action needs a third-party software: Orzeszek Timer by OrzeszekDevelopment`nYou can download it at http://www.orzeszek.org/dev/timer/`nAfter downloading, extract its files to <Enzyme's directory>/external/orztimer/`nDo you want to be redirected to this site?
    IfMsgBox, Yes
     Run, http://www.orzeszek.org/dev/timer/
    return
  }
      
  InputBox, argument, Input timer arguments, Check Orzeszek Timer's webpage for help,,, 250, 120 
  Run, %AppLocation% %argument%,, Hide|UseErrorLevel 

}

urlEncode(url){
  f = %A_FormatInteger%
  SetFormat, Integer, Hex
  While (RegexMatch(url,"\W", var))
      StringReplace, url, url, %var%, % asc(var), All
  StringReplace, url, url, 0x, `%, All
  SetFormat, Integer, %f%
  return url
}

NextDesktopBackground:
  winActivate, ahk_class Progman
  MouseGetPos, xpos, ypos ; get current mouse position
  Click 0,0 ; click in the corner of the desktop, to unselect any selected iconSend 
  Send, +{F10} ; send Shift+F10, the shortcut for right-click
  Send, {n} ; send "n", the key for "next desktop background"
  Click %xpos%, %ypos%, 0 ; put the mouse back at its previous position
return ; done!g

ShutdownPC(value)
{
  Shutdown, %value%
}

ToggleStates(mouseState, hotkeyState)
{

  if mouseState
    Gosub, SuspendGestures
  if hotkeyState
    Gosub, SuspendHotkeys

}

ReloadApp()
{
  Reload
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
    
ChangeProfile(newProfile)
{
  Global
  FileRead, Settings, % SettingsFileURL
  ini_replaceValue(Settings, "Profile", "Active", newProfile)
  ;Msgbox, %Settings%
  SaveInis()
  Reload
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

/*
TestingArguments(vStr, vNum, vChar, vDef=33, vDef2="default", vNum2=1)
{
  Msgbox, Inside function:`n%vStr%, %vNum%, %vChar%, %vDef%, %vDef2%, %vNum2%
}
*/