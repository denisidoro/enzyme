;mgr_SetRButtonHotkey("mgr_MonitorRButton")

CTypes := "Window class|Filename|Title"
CTypesShort := "WClass|Exe|Title"

Profiles := ""
Loop, %A_ScriptDir%\profiles\*, 2, 0
  Profiles .= A_LoopFileName "|"
;Profiles := Substr(Profiles, 1, -1)
;Msgbox, %Profiles%

;MouseMonitorCompleteList := "@LButton|^LButton|!LButton|+LButton|#LButton|@MButton|^MButton|!MButton|+MButton|#MButton|@RButton|^RButton|!RButton|+RButton|#RButton"

;MButtons = Right mouse button|Middle mouse button|Left mouse button|Ctrl|Alt|Shift|Windows key
;MButtonsShort = RB|MB|LB|^|!|+|#

StringSplit, CTypesShortArray, CTypesShort, |
;StringSplit, CTypesArray, CTypes, |

StartWithWindows := ini_getValue(Settings, "Windows", "StartWithWindows")
MouseMonitorList := ini_GetValue(Settings, "Mouse", "MouseMonitorList")
ForceDefaultCommand := ini_GetValue(Settings, "Mouse", "ForceDefaultCommand")

ActiveProfileIndex := GetIndex(Profiles, ActiveProfile)

SaveInis(".bak") ; Create INI backup files

StringSplit, MouseMonitorCompleteListArray, MouseMonitorCompleteList, |
;StringSplit, MouseMonitorList, MouseMonitorListArray, |

Loop, %MouseMonitorCompleteListArray0%
{
  if (inStr(MouseMonitorList, MouseMonitorCompleteListArray%a_index%))
    CheckedMCCheckBox%a_index% = 1
  else
    CheckedMCCheckBox%a_index% = 0  
  ;MsgBox, % MouseMonitorList " - " MouseMonitorCompleteListArray%a_index% " - " CheckedMCCheckBox%a_index% 
}

#Include, editor\GUI.ahk
#Include, editor\ActionList.ahk

Gosub, updateEverything
Gosub, StartJoystickRecognition