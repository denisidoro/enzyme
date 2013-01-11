;-----------------------------------------------------------------
; STARTUP --------------------------------------------------------
;-----------------------------------------------------------------

if isUpgrading
{

SetWorkingDir, %A_ScriptDir%
Menu, Tray, Icon, Shell32.dll, 99
#NoTrayIcon 

process, close, Enzyme.exe

Script_Name = Enzyme :: Upgrade Tool
;IsUpgrading = true

#include upgrade\Main.ahk

Run Editor.exe,,UseErrorLevel
ExitApp

#include upgrade\Functions.ahk

}