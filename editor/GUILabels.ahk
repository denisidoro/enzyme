F12::
Gui, Submit, NoHide
Info := GetWindowInfo(MyDropDown32)
;MsgBox % Info
GuiControl, , MyEdit32, %Info%
return

ShowInfoSimulation:
MsgBox % "Just simulate the desired gesture and its code will pop on the edit control box"
return

OnCheckBoxChange:
Gui, Submit, NoHide
ini_replaceValue(Settings, "Windows", "StartWithWindows", %MyCheckBox3%)
return

UpdateNameHK:
Gui, Submit, NoHide
Name := GetElement(CMNames, MyListBox2)
if !Name
  return
GuiControl,, MyEdit2, %Name%
Command := ini_Get_Section_From_Value(Commands, Name) "_"
GuiControl,, MyEdit22, %Command%  
Gosub, EnableDisableControls
return

ChangeConditionName:
Gui, Submit, NoHide
OldName := GetElement(CGNames, MyListBox3)
NewName = %MyEdit3%
if (!NewName or !OldName)
  return
StringReplace, Groups, Groups, %OldName%, %NewName%, All
Gosub, UpdateEverything
return

ChangeCommandName:
Gui, Submit, NoHide
Gosub, UpdateHotkey
OldName := GetElement(CMNames, MyListBox2)
Command := ini_Get_Section_From_Value(Commands, OldName)
NewName = %MyEdit2%
if (!NewName or !OldName)
  return
StringReplace, Commands, Commands, %OldName%, %NewName%, All
Gosub, UpdateEverything
return

AddActionText:
Gui, Submit, NoHide
Action := GetAction()
if !Action
  return
Name := ActionTemplateTitle_%MyDropDown12%
;MsgBox %MyDropDown12% - %Action%
NewText = %MyEdit13%%Action%%ActionDelimiterEdit%
GuiControl,, MyEdit13, %NewText%
;if (MyEdit12 = "")
  GuiControl,, MyEdit12, %Name%
return

ClearCode:
  GuiControl,, MyEdit13,
return

AddNewActionCommand:
Gui, Submit, NoHide
Section := GetElement(CMNames, MyListBox1)
Section := ini_Get_Section_From_Value(Commands, Section)
Key := GetElement(CGNames, MyDropDown1)
Value = %MyEdit13%
StringReplace, Value, Value, %ActionDelimiterEdit%, |, 1
if (Substr(Value, 0) = "|")
  Value := SubStr(Value, 1, -1)
;MsgBox %Value%
Comment = %MyEdit12%
if (!Section or !Value or !Key)
{
  MsgBox, Please check if you have defined all necessary parameters
  return
}
ini_insertKey(Commands, Section, Key "=" Value ";" Comment, 1)
;MsgBox %Section% - %Key% - %Value% - %Comment%
;MsgBox, %Commands%
Gosub, UpdateEverything
return

UpdateListView1:
Gui, Submit, NoHide
Gui, ListView, MyListView1
LV_Delete()
GuiControl,, MyEdit12,
GuiControl,, MyEdit13,
;LV_Add("", CMKeys%MyListBox1%, CMValues%MyListBox1%, "name2")
StringSplit, CMKeysArray, CMKeys%MyListBox1%, |
StringSplit, CMValuesArray, CMValues%MyListBox1%, `n
Loop, %CMKeysArray0%
{
  ThisKey := CMKeysArray%a_index%
  if (ThisKey != "TriggerName")
  {
    ThisValue := CMValuesArray%a_index%
    RegExMatch(ThisValue, ";\K.+?$", ThisDescription) ; Extract the description if there is one
    ThisValue	:= RegExReplace(ThisValue, ";" ThisDescription "$") ; Remove the description from the command
    LV_Add("", ThisKey, ThisValue, ThisDescription)
  }
}
Gosub, EnableDisableControls
LV_Modify(1, "Select")
return

UpdateListView3:
Gui, Submit, NoHide
Gui, ListView, MyListView3
Name := GetElement(CGNames, MyListBox3)
;if (Name = "Default" or Name = "Disabled" or Name = "Disable")
 ; GuiControl, Disable, MinusButton3
;else
 ; GuiControl, Enable, MinusButton3
GuiControl,, MyEdit3, %Name%
Keys := CGTypes%MyListBox3% 
Values := CGValues%MyListBox3% 
StringSplit, KeysArray, Keys, |
StringSplit, ValuesArray, Values, |
LV_Delete()
Index = 1
Loop, %KeysArray0%
{
  ThisKey := KeysArray%a_index%
  ThisValue := ValuesArray%a_index%
  ;if ThisKey != And
  ;  LV_Add("", ThisKey, ThisValue)
  ;else
  ;  Index := ThisValue + 1
  ;if ThisKey = And
  ;  Index := ThisValue + 1
  Lv_Add("", ThisKey, ThisValue)
}
Index := CGAndOperator%MyListBox3% + 1
;MsgBox, %MyListBox3% - %Index%
GuiControl, Choose, MyDropDown3, %Index%
Gosub, EnableDisableControls
Return

OnHotkeyChange:
Gui, Submit, NoHide
GuiControl,, MyEdit22, KB_%GuiHotkey%_
Return

OnJoystickChange:
Gui, Submit, NoHide
if (RegExMatch(MyEdit23, "\d+Joy\d+$") >= 1)
  GuiControl,, MyEdit22, JS_%MyEdit23%_
;GuiControl,, MyEdit22, % RegExMatch(MyEdit23, "\d+Joy\d+")
Return

OnSpeechChange:
Gui, Submit, NoHide
GuiControl,, MyEdit22, SP_%MyEdit24%_
Return

SpeechHelp:
MsgBox, Enter the desired phrase that will trigger an action`nOnly English words are allowed`nDon't forget to activate speech recognition in settings
Return

KeyHelp:
MsgBox, Press the desired keyboard hotkey combination that will trigger an action`nSome combinations that are not recognized must be inserted manually
Return

JoyHelp:
MsgBox, Press the desired button that will trigger an action`nOnly buttons from the first active joystick are allowed
Return

HelperAction:
MsgBox % "Press F12 on a window to get its info"
Return

GiveCommandName:
Gui, Submit, NoHide
;StringLower, LowerName, MyEdit22
LowerName := MyEdit22
;GuiControl,, MyEdit22, %LowerName%
if (MyEdit2 = "" or InStr(MyEdit2, "_") or InStr(MyEdit2, "New"))
  GuiControl,, MyEdit2, %LowerName%
return

UpdateCommandControls:
Gui, Submit, NoHide
Gui, ListView, MyListView1
Index := LVG_Get(1, "Selected", "List")
if Index > 0
{
LV_GetText(ConditionText, Index, 1)
LV_GetText(ActionText, Index, 2)
ActionText = %ActionText%|
StringReplace, ActionText, ActionText, |, %ActionDelimiterEdit%, 1
LV_GetText(NameText, Index, 3)
Index := GetIndex(CGNames, ConditionText) - 1
GuiControl, Choose, MyDropDown1, %Index%
GuiControl,, MyEdit12, %NameText%
GuiControl,, MyEdit13, %ActionText%
}
Return

DeleteConditionDef:
Gui, Submit, NoHide
Section := GetElement(CGNames, MyListBox3)
Gui, ListView, MyListView3
Index := LVG_Get(1, "Selected", "List") - 1
Key := GetElement(CGTypes%MyListBox3%, Index)
Value := GetElement(CGValues%MyListBox3%, Index)
;Ini_Delete(Groups, Section, Key)
OldString := Key "=" Value
;MsgBox, %MyListBox3% - %Section% - %Index% - %Key% - %Value% - %OldString%
if (Index="" or !Key or !Value)
{
  MsgBox, Select an action first
  return
}
StringReplace, Groups, Groups, %OldString%, , All
;MsgBox, %Groups%
Gosub, UpdateEverything
return

UpdateDropEdit3:
Gui, Submit, NoHide
Gui, ListView, MyListView3
Index := LVG_Get(1, "Selected", "List")
GuiControl,, MyEdit32, % ValuesArray%Index%
;MsgBox, %Index%
;MsgBox % KeysArray%Index%
Index := GetIndex(CTypesShort, KeysArray%Index%)
;MsgBox, Index - %Index%
GuiControl, Choose, MyDropDown32, %Index%
Return

DeleteHotkey:
Gui, Submit, NoHide
Section := GetElement(CMNames, MyListBox2)
Section := ini_Get_Section_From_Value(Commands, Section)
if (!Section)
  return
Ini_Delete(Commands, Section)
Gosub, updateEverything
return

AddGroup:
NowTime := A_Now
ini_insertSection(Groups, "New group (" NowTime ")")
Gosub, updateEverything
return

AddHotkey:
NowTime := A_Now
SectionName := "Please insert a new hotkey. "NowTime
ini_insertSection(Commands, SectionName)
KeyName := "TriggerName=New trigger (" NowTime ")"
ini_insertKey(Commands, SectionName, KeyName) 
;MsgBox, %Commands%
Gosub, updateEverything
return

AddConditionGroup:
Gui, Submit, NoHide
;LV_Add("", CTypesShort%MyDropDown32%, MyEdit32)
Section := GetElement(CGNames, MyListBox3)
NowTime := A_Now
Key := CTypesShortArray%MyDropDown32%
if (!Section or !Key or !MyEdit32)
{
  MsgBox, Please fill in all fields
  return
}
Value := MyEdit32
if (MyDropDown33 = 2 and !InStr(MyEdit32, "!"))
  Value = !%Value%
ini_insertKey(Groups, Section, Key NowTime "=" Value)
ThisAndOperator := MyDropDown3 - 1
if !ThisAndOperator
  ThisAndOperator = 0
if (!ini_replaceValue(Groups, Section, "And", ThisAndOperator))
  ini_insertKey(Groups, Section, "And=" . ThisAndOperator)
StringReplace, Groups, Groups, %NowTime%, , All
;MsgBox, %Section% - %Key% - %MyEdit32%
;MsgBox, %Groups%
Gosub, updateEverything
return

UpdateHotkey:
Gui, Submit, NoHide
Section := GetElement(CMNames, MyListBox2)
Section := ini_Get_Section_From_Value(Commands, Section)
NewSectionName := MyEdit22
if (Substr(NewSectionName, 0) = "_")
  NewSectionName := SubStr(NewSectionName, 1, -1)
if (!Section or !NewSectionName)
  return
StringReplace, Commands, Commands, %Section%, %NewSectionName%, All
;MsgBox, %Commands%
Gosub, updateEverything
return

UpdateActionCommand:
Gui, Submit, NoHide
Gui, ListView, MyListView1
Index := LVG_Get(1, "Selected", "List")
OldKey := CMKeys%MyListBox1%
OldValue := CMValues%MyListBox1%
OldKey := GetElement(OldKey, Index)
OldValue := GetElement(OldValue, Index, "`n")
;MsgBox, %OldKey%
Section := GetElement(CMNames, MyListBox1)
Section := ini_Get_Section_From_Value(Commands, Section)
Key := GetElement(CGNames, MyDropDown1)
Value = %MyEdit13%
StringReplace, Value, Value, %ActionDelimiterEdit%, |, 1
if (Substr(Value, 0) = "|")
  Value := SubStr(Value, 1, -1)
Comment = %MyEdit12%
;MsgBox, %MyListBox1% - %Index% - %OldKey% - %OldValue% - %Section% - %Key% - %Value% - %Comment%
if (!Section or !Index or !OldKey or !Key or !Value)
{
  Msgbox, Couldn't update the desired action
  return
}
ini_replaceKey(Commands, Section, OldKey, Key "=" Value ";" Comment, OldValue)
;MsgBox, %Commands%
Gosub, UpdateEverything
Return

UpdateConditionGroup:
Gui, Submit, NoHide
;LV_Add("", CTypesShort%MyDropDown32%, MyEdit32)
Section := GetElement(CGNames, MyListBox3)
ThisAndOperator := MyDropDown3 - 1
if !ThisAndOperator
  ThisAndOperator = 0
if (!ini_replaceValue(Groups, Section, "And", ThisAndOperator))
  ini_insertKey(Groups, Section, "And=" . ThisAndOperator)
;MsgBox, %MyDropDown3% - %ThisAndOperator% - %Section%`n`n%Groups%
Gui, ListView, MyListView3
Index := LVG_Get(1, "Selected", "List") - 1
NewKey := CTypesShortArray%MyDropDown32%
OldKey := CGTypes%MyListBox3%
OldKey := GetElement(OldKey, Index)
NewValue := MyEdit32
OldValue := CGValues%MyListBox3%
OldValue := GetElement(OldValue, Index)
;MsgBox, %Section% - %OldKey% - %NewKey%
OldString := OldKey "=" OldValue
NewString := NewKey "=" NewValue
;MsgBox, %OldString% - %NewString%
;ini_replaceKey(Groups, Section, Key, Key "=" MyEdit32)
if (!Index or !OldKey or !NewKey)
  return
StringReplace, Groups, Groups, %OldString%, %NewString%, All
;MsgBox, %Groups%
Gosub, updateEverything
return

DeleteGroup:
Gui, Submit, NoHide
Section := GetElement(CGNames, MyListBox3)
if (!Section)
  return
Ini_Delete(Groups, Section)
Gosub, updateEverything
return

GroupGoUp:
Gui, Submit, NoHide
Section1 := GetElement(CGNames, MyListBox3)
OtherIndex := MyListBox3 - 1
Section2 := GetElement(CGNames, OtherIndex)
ini_Swap_Sections(Groups, Section1, Section2)
GuiControlGet, ChooseMyListBox3, , MyListBox3
ChooseMyListBox3--
GuiControl, Choose, MyListBox3, %ChooseMyListBox3%
Gosub, updateEverything
return

GroupGoDown:
Gui, Submit, NoHide
Section1 := GetElement(CGNames, MyListBox3)
OtherIndex := MyListBox3 + 1
Section2 := GetElement(CGNames, OtherIndex)
ini_Swap_Sections(Groups, Section2, Section1)
GuiControlGet, ChooseMyListBox3, , MyListBox3
ChooseMyListBox3++
GuiControl, Choose, MyListBox3, %ChooseMyListBox3%
Gosub, updateEverything
return

HotkeyGoUp:
Gui, Submit, NoHide
Section1 := GetElement(CMNames, MyListBox2)
OtherIndex := MyListBox2 - 1
Section2 := GetElement(CMNames, OtherIndex)
Section1 := ini_Get_Section_From_Value(Commands, Section1)
Section2 := ini_Get_Section_From_Value(Commands, Section2)
;MsgBox, %MyListBox2% - %Section1% - %Section2%
ini_Swap_Sections(Commands, Section1, Section2)
GuiControlGet, ChooseMyListBox2, , MyListBox2
ChooseMyListBox2--
GuiControl, Choose, MyListBox2, %ChooseMyListBox2%
Gosub, updateEverything
return

HotkeyGoDown:
Gui, Submit, NoHide
Section1 := GetElement(CMNames, MyListBox2)
OtherIndex := MyListBox2 + 1
Section2 := GetElement(CMNames, OtherIndex)
Section1 := ini_Get_Section_From_Value(Commands, Section1)
Section2 := ini_Get_Section_From_Value(Commands, Section2)
;MsgBox, %MyListBox2% - %Section1% - %Section2%
ini_Swap_Sections(Commands, Section2, Section1)
GuiControlGet, ChooseMyListBox2, , MyListBox2
ChooseMyListBox2++
GuiControl, Choose, MyListBox2, %ChooseMyListBox2%
Gosub, updateEverything
return

ConditionGoUp:
Gui, Submit, NoHide
Section := GetElement(CMNames, MyListBox1)
Section := ini_Get_Section_From_Value(Commands, Section)
Gui, ListView, MyListView1
Index := LVG_Get(1, "Selected", "List") + 1
if !Index
{
  MsgBox, Select an action first
  return
}
Key1 := CMKeysArray%Index%
OtherIndex := Index - 1
Key2 := CMKeysArray%OtherIndex%
;MsgBox, %Section% - %Index% - %Key1% - %Key2%
ini_Swap_Keys(Commands, Section, Key1, Key2)
;MsgBox, %Commands%
ChooseMyListView1 := LVG_Get(1, "Selected", "List")
ChooseMyListView1--
LV_Modify(%ChooseMyListView1%, "Select")
Gosub, updateEverything
return

ConditionDelete:
Gui, Submit, NoHide
Section := GetElement(CMNames, MyListBox1)
Section := ini_Get_Section_From_Value(Commands, Section)
Gui, ListView, MyListView1
Index := LVG_Get(1, "Selected", "List") + 1
if !Index
{
  MsgBox, Select an action first
  return
}
Key := CMKeysArray%Index%
Ini_Delete(Commands, Section, Key)
;MsgBox, %Section% - %Key%
;MsgBox, %Commands%
Gosub, updateEverything
return

GiveSomeHelp:
  helpLocation := "enzyme-help-file.chm"
  if fileExist(helpLocation) 
    Run %helpLocation%,,UseErrorLevel
  else
  {
    Msgbox, 4, %Script_Name%, You haven't downloaded the help file yet`n`nDo you want to download it now?
    ifMsgbox Yes
    {
      UrlDownloadToFile, https://github.com/denisidoro/enzyme/blob/master/enzyme-help-file.chm?raw=true, %HelpLocation%
      Msgbox, 4, %Script_Name%, Finished downloading help file!`n`nDo you want to see it now?
      ifMsgbox Yes
        Run %helpLocation%,,UseErrorLevel
    }
  } 
return

ConditionGoDown:
Gui, Submit, NoHide
Section := GetElement(CMNames, MyListBox1)
Section := ini_Get_Section_From_Value(Commands, Section)
Gui, ListView, MyListView1
Index := LVG_Get(1, "Selected", "List") + 1
if !Index
{
  MsgBox, Select an action first
  return
}
Key1 := CMKeysArray%Index%
OtherIndex := Index + 1
Key2 := CMKeysArray%OtherIndex%
;MsgBox, %Section% - %Index% - %Key1% - %Key2%
ini_Swap_Keys(Commands, Section, Key2, Key1)
;MsgBox, %Commands%
ChooseMyListView1 := LVG_Get(1, "Selected", "List")
ChooseMyListView1++
LV_Modify(%ChooseMyListView1%, "Select")
Gosub, updateEverything
return

AddHotkeyPrefixSuffix(suffix="", prefix="")
{
  Global
  Gui, Submit, NoHide
  NewText = %MyEdit22%
  if NewText = Define a new hotkey_
    NewText = 
  if prefix !=
    NewText = %prefix%_%NewText% 
  if suffix !=
    NewText = %NewText%%suffix%_
  GuiControl,, MyEdit22, %NewText%
}

UpdateMouseButtons:
Gui, Submit, NoHide
Prefix := GetElement(MButtonsShort, MyListBox22-1)
;MsgBox %MyListBox22% - %Prefix%
AddHotKeyPrefixSuffix(,Prefix)
return

EditAdvSettings:
  Msgbox, 4, %Script_Name%, This will close this window and you will lose all unsaved changes`n`nDo you want to continue?
  ifMsgbox Yes
  {
    G_EditFile(A_ScriptDir "\profiles\Settings.ini")
    ExitApp
  }
return

ImportProfile:
  MsgBox, 4, %Script_Name%, Do you want to save your actual profile?`nUnsaved changes will be lost otherwise
  IfMsgBox Yes
  {
    CheckSettings()
    SaveInis()
  }
  FileSelectFile, FileLocation, 3, %A_ScriptDir%\profiles\, Open profile file to import, Enzyme profiles (*.zip; *.rar) 
  if (!FoundPos := RegExMatch(FileLocation, "i)^(.*)\\(?P<Name>(.*))\.(?P<Extension>(.*))$", Imported))
    MsgBox, , %Script_Name%, An error ocurred!
  ;Msgbox, %FileLocation%`n%FoundPos%`n%ImportedName%`n%ImportedExtension%
  ;Msgbox, % A_ScriptDir . "\profiles\" . ImportedName . "\"
  Unz(FileLocation, A_ScriptDir . "\profiles\" . ImportedName . "\")
  MsgBox, 4, %Script_Name%, Profile imported!`nDo you want to switch to this new profile?
  ifMsgBox Yes
  {
    ini_replaceValue(Settings, "Profile", "Active", ImportedName)
    ;Msgbox, %Settings%
    SaveInis()
  }
  Reload
return

ExportProfile:
  CheckSettings()
  SaveInis()
  FileSelectFile, FileLocation, S24, %A_ScriptDir%\profiles\%ActiveProfile%.zip, Select destination file, Enzyme profiles (*.zip; *.rar)
  if (!InStr(FileLocation, "."))
    FileLocation .= ".zip"
  Zip(A_ScriptDir . "\profiles\" . ActiveProfile . "\", FileLocation)
  Msgbox, , %Script_Name%, Profile exported!
return

GetMoreProfiles:
  Run, https://github.com/denisidoro/enzyme/tree/master/profiles
return

UpdateActiveProfile:
  Gui, Submit, NoHide
  MsgBox, 4, %Script_Name%, Do you want to save your actual profile?`nUnsaved changes will be lost otherwise
  IfMsgBox Yes
  {
    CheckSettings()
    SaveInis()
  }
  ini_replaceValue(Settings, "Profile", "Active", MyDropDown4)
  SaveInis()
  Reload
return

ExecuteUpgrade:
  Msgbox, 4, %Script_Name%, This will close this window and you will lose all unsaved changes`n`nDo you want to continue?
  ifMsgbox Yes
  {
    Run Editor.exe forceUpgrade,,UseErrorLevel
    ExitApp
  }
return

/*
HK1:
AddHotkeyPrefixSuffix("UL")
return

HK2:
AddHotkeyPrefixSuffix("U")
return

HK3:
AddHotkeyPrefixSuffix("UR")
return

HK4:
AddHotkeyPrefixSuffix("L")
return

HK5:
GuiControl,, MyEdit22, 
return

HK6:
AddHotkeyPrefixSuffix("R")
return

HK7:
AddHotkeyPrefixSuffix("DL")
return

HK8:
AddHotkeyPrefixSuffix("D")
return

HK9:
AddHotkeyPrefixSuffix("DR")
return
*/