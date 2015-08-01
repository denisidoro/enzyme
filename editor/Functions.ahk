GetElement(String, Index, Delimiter="|")
{

  Index++
  StringSplit, StringArray, String, %Delimiter%
  return StringArray%Index%

}

GetIndex(String, Element, Delimiter="|")
{

  StringSplit, StringArray, String, %Delimiter%
  ;MsgBox, %String%
  Loop, %StringArray0%
  {
    ;output := "String - " StringArray%A_Index%
    ;output := "String - "
    ;MsgBox, %output%
    if StringArray%A_Index% = %Element%
      return A_Index
  }
  return -1

}

GetWindowInfo(index=0)
{
	MouseGetPos, mx, my, WinID					; Get the current's window ID
	WinGetClass, WindowInfo1, ahk_id %WinID%	; Get the current's window class
	WinGetTitle, WindowInfo3, ahk_id %WinID%	; Get the current's window title
  WinGet, WindowInfo2, ProcessName, ahk_id %WinID% ; Get the current's window text
  return WindowInfo%index%
}

Control_GetClassNN(hWndWindow,hWndControl){
   DetectHiddenWindows, On
   WinGet, ClassNNList, ControlList, ahk_id %hWndWindow%
   Loop, PARSE, ClassNNList, `n
   {
      ControlGet, hwnd, hwnd,,%A_LoopField%,ahk_id %hWndWindow%
      if (hWnd = hWndControl)
         return A_LoopField
   }
}

SetToStartWithWindows(Start)
{

  SplitPath, A_Scriptname, , , , OutNameNoExt
  InFile := A_ScriptDir . "\Enzyme.exe"
  OutFile=%A_Startup%\Enzyme.lnk

  if Start = 0
  {
    if FileExist(OutFile)
      FileDelete, %OutFile%
  }
  
  else
  {
    if !FileExist(OutFile)
      FileCreateShortcut, %InFile%, %OutFile%
  }
    
  ;SetWorkingDir, %A_ScriptDir%
  
}

RemoveElementFromIndex(String, Index, Delimiter="|")
{

  StringSplit, StringArray, String, %Delimiter%
  
  ;MsgBox, AndIndex: %Index%
  
  NewString := ""
  Loop, %StringArray0%
  {
    if (a_index != Index or Index == -1)
      NewString .= GetElement(String, a_index - 1) "|"
  }
  NewString := SubStr(NewString, 1, -1)
  
  return NewString

}

CheckSettings()
{

  Global
  Gui, Submit, NoHide
  
  ThisMCList := ""
  Loop, 15
  {
    if MCCheckBox%a_index%
      ThisMCList := ThisMCList MouseMonitorCompleteListArray%a_index% "|"
  }
  ThisMCList := SubStr(ThisMCList, 1, -1)
  
  ini_replaceValue(Settings, "Windows", "StartWithWindows", MyCheckBox4)
  ini_replaceValue(Settings, "Performance", "StoreINIFiles", MyCheckBox41)
  ini_replaceValue(Settings, "Mouse", "ForceDefaultCommand", MyCheckBox42)
  ini_replaceValue(Settings, "Mouse", "MinimalDistance", MyEdit4)
  ini_replaceValue(Settings, "Mouse", "MouseMonitorList", ThisMCList)
  ini_replaceValue(Settings, "Speech", "UseSpeechRecognition", MyCheckBox43)
  SetToStartWithWindows(MyCheckBox4)
  
  ;MsgBox %Settings%

}



AddActionTemplate(title,script){
  Global
	static ActionTemplate_Count=0
	ActionTemplate_Count++
	ActionTemplate_%ActionTemplate_Count%:=script
	ActionTemplateTitle_%ActionTemplate_Count%:=title
  ;MsgBox, %title% - %script%
	GuiControl,,MyDropDown12,%title%
}

GetAction() 
{
  Global
	Gui,Submit,NoHide
  ;MsgBox % MyDropDown12 "-" ActionTemplate_%MyDropDown12%
	if(IsLabel("Editor_" ActionTemplate_%MyDropDown12%)){
		Gosub,% "Editor_" ActionTemplate_%MyDropDown12%
	}else{
		ActionLine:=ActionTemplate_%MyDropDown12%
    
    ; Gets var contents
		loop
    {
			if(RegExMatch(ActionLine,"%\((.+?)\)%",$))
				ActionLine:=RegExReplace(ActionLine,"%\((.+?)\)%",%$1%,OutputVarCount,1)
			else
				break
		}
    
    ; Asks for parameters
		loop{
      ;Msgbox loop %a_index%`n%ActionLine%`n%OutputVarCount%
			if(RegExMatch(ActionLine,"%\[(.+?)\]%",$)){
        
				InputBox,ActionLineOption,Input Parameters,%$1%
				if(ErrorLevel){
					return
				}
				ActionLine:=RegExReplace(ActionLine,"%\[(.+?)\]%",ActionLineOption,OutputVarCount,1)
			}else{
				break
			}
		}
    ;MsgBox ActionLine: %ActionLine%
    return ActionLine
	}
}


EnableDisableControls:

  Gui, Submit, NoHide
  
  EnableContent1 := (!MyListBox1) ? 0 : 1
  GuiControl, Enable%EnableContent1%, MyButton1
  GuiControl, Enable%EnableContent1%, MyButton12  
  GuiControl, Enable%EnableContent1%, MinusButton1 
  GuiControl, Enable%EnableContent1%, UpButton1 
  GuiControl, Enable%EnableContent1%, DownButton1 
  
  EnableContent2 := (!MyListBox2) ? 0 : 1
  GuiControl, Enable%EnableContent2%, MyButton2
  GuiControl, Enable%EnableContent2%, MinusButton2 
  GuiControl, Enable%EnableContent2%, UpButton2
  GuiControl, Enable%EnableContent2%, DownButton2 
  GuiControl, Enable%EnableContent2%, MyEdit2
  GuiControl, Enable%EnableContent2%, MyEdit22
  GuiControl, Enable%EnableContent2%, MyEdit23
  GuiControl, Enable%EnableContent2%, MyEdit24
  GuiControl, Enable%EnableContent2%, GuiHotkey
  
  EnableContent3 := (!MyListBox3) ? 0 : 1
  if (InStr(GetElement(CGNames, MyListBox3), "Disable"))
    EnableContent3 = 0
  GuiControl, Enable%EnableContent3%, MyEdit3
  GuiControl, Enable%EnableContent3%, MyButton30
  GuiControl, Enable%EnableContent3%, MyButton3
  GuiControl, Enable%EnableContent3%, MyButton32
  GuiControl, Enable%EnableContent3%, MyButton33
  GuiControl, Enable%EnableContent3%, MinusButton3 
  GuiControl, Enable%EnableContent3%, UpButton3
  GuiControl, Enable%EnableContent3%, DownButton3
  if (MyListBox3 >= 1 and MyListBox3 <= 3)
  {
    GuiControl, Enable0, MinusButton3
    GuiControl, Enable0, UpButton3
    GuiControl, Enable0, DownButton3
  }
  if (MyListBox3 == 3 and EnableContent3)
  {
    GuiControl, Enable1, MinusButton3
    GuiControl, Enable1, DownButton3
  }

return


updateEverything:

  Gui, Submit, NoHide
  GuiControlGet, ChooseMyListBox1, , MyListBox1
  GuiControlGet, ChooseMyListBox2, , MyListBox2
  GuiControlGet, ChooseMyListBox3, , MyListBox3
  GuiControlGet, ChooseMyDropDown1, , MyDropDown1
  GuiControlGet, ChooseMyDropDown12, , MyDropDown12
  GuiControlGet, ChooseMyDropDown3, , MyDropDown3
  GuiControlGet, ChooseMyDropDown32, , MyDropDown32
  
  if !ChooseMyDropDown1
    ChooseMyDropDown1 = 1
  if !ChooseMyDropDown12
    ChooseMyDropDown12 = 1
  if !ChooseMyDropDown3
    ChooseMyDropDown3 = 1
  if !ChooseMyDropDown32
    ChooseMyDropDown32 = 1
  
  Gui, ListView, MyListView1
  ChooseMyListView1 := LVG_Get(1, "Selected", "List")
  Gui, ListView, MyListView3
  ChooseMyListView3 := LVG_Get(1, "Selected", "List")

  ; Get command hotkeys
  CMHotkeys := ini_getAllSectionNames(Commands)
  StringSplit, CMHotkeysArray, CMHotkeys, `,
  StringReplace, CMHotkeys, CMHotkeys, `,, |, All

  ; Get command names and values
  CMNames := ""
  Loop, %CMHotkeysArray0%
  {

    ThisCMHotkey := CMHotkeysArray%a_index%
    ThisName := ini_getValue(Commands, ThisCMHotkey, "TriggerName")
    CMNames .= ThisName "|"
    CMKeys%a_index% := ini_getAllKeyNames(Commands, ThisCMHotkey)
    StringReplace, CMKeys%a_index%, CMKeys%a_index%, `,, |, All
    CMValues%a_index% := ini_getAllValues(Commands, ThisCMHotkey)
    ;StringReplace, CMValues%a_index%, CMValues%a_index%, `n, |, All
    
  }

  ; Get condition group names
  CGNames := ini_getAllSectionNames(Groups)
  StringSplit, CGNamesArray, CGNames, `,
  StringReplace, CGNames, CGNames, `,, |, All
  ;MsgBox, %CGNames%
  ;CGNames := "Default|" CGNames

  ; Get condition types and values
  Loop, %CGNamesArray0%
  {

    ThisCGName := CGNamesArray%a_index%
    CGTypes%a_index% := ini_getAllKeyNames(Groups, ThisCGName)
    CGValues%a_index% := ini_getAllValues(Groups, ThisCGName)
    StringReplace, CGTypes%a_index%, CGTypes%a_index%, `,, |, All
    StringReplace, CGValues%a_index%, CGValues%a_index%, `n, |, All
    
    AndOperatorIndex := GetIndex(CGTypes%a_index%, "And")
    if AndOperatorIndex >= 0
    {
      CGAndOperator%a_index% := GetElement(CGValues%a_index%, AndOperatorIndex - 1)
      CGTypes%a_index% := RemoveElementFromIndex(CGTypes%a_index%, AndOperatorIndex)
      CGValues%a_index% := RemoveElementFromIndex(CGValues%a_index%, AndOperatorIndex)
    }
    else
      CGAndOperator%a_index% = 0
    
    ;MsgBox, % ThisCGName " - " AndOperatorIndex " - " CGAndOperator%a_index% 
    
  }
  
  StringSplit, CMNamesArray, CMNames, |
  
  CMNames := "|"CMNames
  CGNames := "|"CGNames
  ;CTypes := "|"CTypes
  
  GuiControl,, MyListBox1, %CMNames%
  GuiControl,, MyDropDown1, %CGNames%
  GuiControl,, MyListBox2, %CMNames%
  GuiControl,, MyListBox3, %CGNames%
  ;GuiControl,, MyDropDown32, %CTypes%
 
  GuiControl, Choose, MyDropDown1, %ChooseMyDropDown1%
  GuiControl, Choose, MyDropDown12, %ChooseMyDropDown12%
  GuiControl, Choose, MyDropDown3, %ChooseMyDropDown3%
  GuiControl, Choose, MyDropDown32, %ChooseMyDropDown32%
  GuiControl, Choose, MyListBox1, %ChooseMyListBox1%
  GuiControl, Choose, MyListBox2, %ChooseMyListBox2%
  GuiControl, Choose, MyListBox3, %ChooseMyListBox3%
  
  Gosub, UpdateListView1
  Gosub, UpdateListView3
  
  Gosub, EnableDisableControls
  
  Gui, ListView, MyListView1
  LV_Modify(%ChooseMyListView1%, "Select")
  Gui, ListView, MyListView3
  LV_Modify(%ChooseMyListView3%, "Select")

return