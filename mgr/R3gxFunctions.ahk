/*
Name	: Mouse Gesture Recognizer v0.8
Author	: R3gX
Link	: http://www.autohotkey.com/forum/viewtopic.php?t=71666

Description :
	This script allows you to use mouse gestures to
	- launch a file, a folder or an url
	- use a label or a function (with parameters!)
	- send a text or a macro

Tested with :
	AutoHotkey_L
	
Thanks to :
	@Carrozza & @sumon for their interest

Licence	:
	Use in source, library and binary form is permitted.
	Redistribution and modification must meet the following conditions:
	- My nickname (R3gX) and the origin (link) must be reproduced by binaries, or attached in the documentation.
	- If changes are made to my work, you are encouraged (yet not obliged) to post the changes for others to view, on the Autohotkey forum.
	ALL MY SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY EXPRESSED OR IMPLIED WARRANTIES.
*/

mgr_InitAllHKCommands(State=1)
{

  ;Global Commands, CommandsFileURL
  ;Global CommandsFileURL, IsEditing, pstate
  Global
  
  if (IsEditing)
    return
  
  if (!Commands)
    FileRead, Commands, % CommandsFileURL
    
  if State = 0
    State := "Off"
  else
    State := "On"

  Sections := ini_getAllSectionNames(Commands)
  ;MsgBox, %Sections%

  StringSplit, SectionsArray, Sections, `,
  
  TriggerPrefixes := "KB_|JS_|SP_"
  StringSplit, TriggerPrefixesArray, TriggerPrefixes, |

  Loop, %SectionsArray0%
  {
    
    ThisSection := SectionsArray%a_index%  
    
    Loop, %TriggerPrefixesArray0%
    {
    
      ThisPrefix := TriggerPrefixesArray%a_index%
      StringGetPos, pos, ThisSection, %ThisPrefix%
      
      if (pos >= 0)
      {
        
        StringReplace, ThisSection, ThisSection, %ThisPrefix%
        
        if (a_index <= 2) ; If contains KB_ or JS_
          Hotkey, %ThisSection%, mgr_MonitorHotKeys, UseErrorLevel %State%
        else if (a_index = 3 and UseSpeechRecognition) ; If contains SP_
          pstate.AddWordTransition(ComObjParameter(13,0), ThisSection)
          ;COM_Invoke(pstate, "AddWordTransition", "+" . 0, ThisSection) ; Old speech recog
          
        break ; Prevents unnecessary conditional checks
        
      }
    
    }
    
  } 
  
  if (!StoreINIFiles)
    ClearINIFilesFromMemory()

}

mgr_ToggleHotkeysState()
{
  static HK_State := 0
  HK_State := (HK_State=1) ? 0 : 1
  mgr_InitAllHKCommands(HK_State)
  return HK_State
}

mgr_MonitorHotKeys:

  if !A_ThisHotkey
    return
  
  if (InStr(A_ThisHotkey, "Joy"))
    WatchedHotkey = JS_%A_ThisHotkey%
  else
    WatchedHotkey = KB_%A_ThisHotkey%
    
  mgr_Execute(mgr_GetCommand(WatchedHotkey, IsFromMouse=0, ReturnDescription=1))
  ;output := mgr_GetCommand(A_ThisHotkey, IsFromMouse=0, ReturnDescription=1)
  ;MsgBox, %output%
  
return

mgr_RemoveTips_tmr:
ToolTip
TrayTip
SetTimer, mgr_RemoveTips_tmr, Off
Return

mgr_GetCommand(Gesture, IsFromMouse=1, ReturnDescription=0, ConditionGroup="")
{ ; Get the command associated with the gesture depending on the active window
	; ReturnDescription = 0 : Even if there is a description,	return the command
	; ReturnDescription = 1 : If there is a description, 		return the description instead of the command

  Global Commands, CommandsFileURL
  
  ;Msgbox, Gesture: %Gesture%
  
  if (!Commands)
    FileRead, Commands, % CommandsFileURL
  
  if !Gesture
    return

  if ConditionGroup =
    ConditionGroup := mgr_GetConditionGroup()  
  
  if ConditionGroup = Disabled
    return
  
  ;FileURL := isFromMouse ? "MGR/MouseCommands.ini" : "MGR/KeyboardCommands.ini"
  ;CommandsFileURL := "MGR/Commands.ini"
  ;MsgBox, %FileURL%
  ;FileRead, Commands, % FileURL

  ;MsgBox, Gesture: %Gesture%`n`nCommands:`n%Commands%
  
  KeyNames := ini_getAllKeyNames(Commands, Gesture)
  ;MsgBox, %KeyNames%

  StringSplit, KeyNamesArray, KeyNames, `,

  Loop, %KeyNamesArray0%
  {

    ThisGroup := KeyNamesArray%a_index%
    
    if (ThisGroup = ConditionGroup or InStr(ThisGroup, "Default"))
    {
    
      Command := ini_getValue(Commands, Gesture, ThisGroup)
      
    	Command	:= RegExReplace(Command, "\s+", " ")							; Delete duplicated spaces and tabs
    	RegExMatch(Command, ";\K.+?$", Description)									; Extract the description if there is one
    	Command	:= RegExReplace(Command, ";" Description "$")					; Remove the description from the command
    	ReturnedValue	:= Description && ReturnDescription ? Description : Command	; Give the priority to the description
    	ReturnedValue := RegExReplace(ReturnedValue, "(^\s*|\s*$)")								; Trim beginning/ending spaces and tabs
      
      ;printText = Gesture: %Gesture%`nConditionGroup: %ConditionGroup%`nCommand: %Command%`nReturnedValue: %ReturnedValue%`nDescription: %Description%
      ;ShowTrayTip(printText)
      ;break
  
      if (!Commands)
        ClearINIFilesFromMemory()
           
      ;MsgBox, Command: %Command%`nDescription: %Description%`nGroup: %ConditionGroup%
           
      return ReturnedValue
      
    }

  }
  
  ;MsgBox, Couldn't find any function`nGesture: %Gesture%`nGroup: %ConditionGroup%
  
}  

mgr_GetConditionGroup(debug=false)
{

  Global Groups, GroupsFileURL
  
  if (!Groups)
    FileRead, Groups, % GroupsFileURL

	TitleMatchMode := A_TitleMatchMode			; Save the current setting 
	SetTitleMatchMode, 2						;	and set it to 2
	MouseGetPos, mx, my, WinID					; Get the current's window ID
	WinGetClass, WindowClass, ahk_id %WinID%	; Get the current's window class
	WinGetTitle, WindowTitle, ahk_id %WinID%	; Get the current's window title
  WinGet, WindowFileName, ProcessName, ahk_id %WinID% ; Get the current's window text
	SetTitleMatchMode, %TitleMatchMode%		; Restore the last settings
  
  if debug
  {
    printText = TitleMatchMode: %TitleMatchMode%`nWindowClass: %WindowClass%`nWindowTitle: %WindowTitle%`nWindowFileName: %WindowFileName%
    MsgBox, %printText%
  }
  
  ReturnedValue = Default
  ;GroupsFileURL := "profiles\default\ConditionGroups.ini"
  ;FileRead, Groups, % GroupsFileURL
  
  Sections := ini_getAllSectionNames(Groups)
  ;printText = Sections: %Sections%
  ;MsgBox, %printText%
  
  StringSplit, SectionsArray, Sections, `,
  
  ;MsgBox, %Groups%

  Loop, %SectionsArray0%
  {

    AndOperator := ini_getValue(Groups, SectionsArray%a_index%, "And")
    if !AndOperator
      AndOperator = 0
    ;MsgBox a_index: %a_index% - AndOperator: %AndOperator%
  
    ThisSection := SectionsArray%a_index%
    ThisSectionContent := ini_getSection(Groups, ThisSection)
    
    StringGetPos, pos, ThisSectionContent, !
    ThereIsExclamation := (pos >= 0) ? 1 : 0
    
    NeedlesArray1 = WClass=%WindowClass%
    NeedlesArray2 = Title=%WindowTitle%
    NeedlesArray3 = Exe=%WindowFileName%
    
    ;Msgbox, there is exclamation: %ThereIsExclamation%
    
    if !ThereIsExclamation
    {
      
      Loop 3
      {
      
        Needle := NeedlesArray%a_index%    
        StringGetPos, pos, ThisSectionContent, %Needle%
      
        ;printText = Needle: %Needle%`nPos: %pos%
        ;MsgBox, %printText%
      
        if (pos >= 0)
        {
          ReturnedValue = %ThisSection%
          ;MsgBox %ReturnedValue% - %AndOperator% - %a_index%
          if ((!AndOperator or a_index = 3) and !ThereIsExclamation)
          {
            ;MsgBox, returnfromloop1
            return ReturnedValue          
          }
        }
        
        else
          ReturnedValue = Default
          
      }   
    
    }
    
    else
    {
      
      ;MsgBox, inside loop 2
          
      Loop 3
      {
      
        StringReplace, Needle, NeedlesArray%a_index%, =, =!
        StringGetPos, pos, ThisSectionContent, %Needle%
      
        ;printText = Needle: %Needle%`nPos: %pos%
        ;MsgBox, %printText%
        
        if (pos >= 0)
        {
          ReturnedValue := "Disabled"
          ;MsgBox, %ReturnedValue% - %AndOperator% - %a_index%
          if (!AndOperator or a_index=3)
          {
            ;MsgBox, returnfromloop2
            return ReturnedValue          
          }
        }
        
        else
          ReturnedValue = Default      
          
      }
    
    }

    
  }
  
  return "Couldn't determine"
  ;return "Default"

}  

mgr_Execute(Commands)
{ ; Execute the command (shortcut, url, function, label, macro or text)

  Global IsEditing
  
  if IsEditing or !Commands
    return -1

  ;MsgBox, All commands: %Commands%
  
  Loop, Parse, Commands, |
  {
  
    Command := A_LoopField

  	Transform, Command, Deref, % Command
  	If !(Command := Trim(Command)) ; After the Trim operation, if there is no command then return
  		Return	
  	
    ;If (RegExMatch(Command, "^(?P<Func>\w+)\(\s*(?P<Params>.*?)\s*\)", m) && IsFunc(mFunc)){
    If (RegExMatch(Command, "^(?P<Func>\w+)\(\s*(?P<Params>.*)\s*\)", m) && IsFunc(mFunc)){
  		;Loop, Parse, mParams, CSV, %A_Space%%A_Tab%
  		;Loop, Parse, mParams, `, %A_Space%%A_Tab%
  		Loop, Parse, mParams, `,
      {
        params%A_Index% := A_LoopField
        if (InStr(params%A_Index%, """"))
          params%A_Index% := Substr(params%A_Index%, 2, -1)
      }
  		;MsgBox, %mParams%`n(%params1%,%params2%,%params3%,%params4%,%params5%)
  		%mFunc%(params1,params2,params3,params4,params5)
  	} 
    
  	Else If (RegExMatch(Command, "^\w+(?:)", Label) && IsLabel(Label))
  		Gosub, %Label%
      
    Else	; The command is not a function so it's a macro or a text
  		SendInput, % Command
      
  }
      
}


/*
mgr_Execute(Commands)
{ ; Execute the command (shortcut, url, function, label, macro or text)

  Global IsEditing
  
  if IsEditing or !Commands
    return -1

  ;MsgBox, All commands: %Commands%
  StringSplit, CommandArray, Commands, |
  
  ;MsgBox Executing:`n%Commands%
  ;return
  
  Loop, %CommandArray0%
  {
  
    Command := CommandArray%a_index%
    ;MsgBox, Command %a_index% is %Command%.
  
  	If !Command
  		Return 
  	Command := RegExReplace(Command, "(^\s*|\s*$)")
  	Transform, Command, Deref, % Command
  	If mgr_IsShortcut(Command)
  		Run(Command)
  	Else If (RegExMatch(Command, "^(?P<Func>\w+)\(\s*(?P<Params>.*?)\s*\)", m) && IsFunc(mFunc))
  	{
  		If mParams or mParams = 0
  		{
  			Loop, Parse, mParams, `,
  			{
          param%A_Index% := A_LoopField
          if (!param%A_Index%)
            Msgbox, %A_Index%
        }          
  			msgbox, %mParams%`n(%param1%, %param2%, %param3%, %param4%, %param5%, %param6%, %param7%, %param8%, %param9%, %param10%)
  			%mFunc%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10)
  			;%mFunc%(mParams)
  		} Else
  			%mFunc%()
  	}
  	Else If (RegExMatch(Command, "^\w+(?:)", Label) && IsLabel(Label))
  		Gosub, %Label%
  	Else If (!mgr_IsShortcut(Command) && RegExMatch(Command, "^(?!\{Raw\})")) ; Is not a shortcut and not begins with {Raw} = Macro
  		SendInput, % Command
  	Else If (!mgr_IsShortcut(Command) && RegExMatch(Command, "^\{Raw\}")) ; Is not a shortcut and begins with {Raw} = Text
  	{
  		Command := RegExReplace(Command, "``n", "`n")
  		Command := RegExReplace(Command, "``r", "`r")
  		Command := RegExReplace(Command, "``t", A_Tab)
  		SendInput, % Command
  	}
  
  }
  
  return
  
}
*/

mgr_IsShortcut(command)
{
	If FileExist(command)
		return, "normal"
	Else If (RegExMatch(command, "^\s*""(?P<Path>.+?\.exe)""\s+.+", m) && FileExist(mPath))
		return, "with_parameters"
	Else If RegExMatch(command, "^\s*((mailto\:|(news|(ht|f)tp(s?))\://){1}\S+)\s*$")
		return, "url"
	Else
		return, ""
}

ClearINIFilesFromMemory()
{

  Global Commands, Groups, Settings
  Commands := ""
  Groups := ""
  Settings := ""

}