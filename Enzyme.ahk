#NoEnv
#UseHook, On

SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

;Menu, Tray, Icon, Shell32.dll, 99

Script_Name := "Enzyme" ;Your script name
#Include %A_ScriptDir%  ; Changes the working directory for subsequent #Includes and FileInstalls.
#include, common\FileLocations.ahk
#Include, common\StructureVersion.ahk

;about_version = Version %Version_Number%

; Checks for parameters
if 0 > 0
{
  Loop, %0%  ; For each parameter:
  {
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    if (RegExMatch(param, "a=(.*)", $))
    {
      ;Msgbox, % $1
      mgr_Execute($1)
      ExitApp
    }
  }
  ExitApp
}

#SingleInstance, Force

Menu, Tray, NoStandard ; only use this menu
menu, tray, tip, %Script_Name%
Menu, Tray, Click, 2  ; Remove this line if you prefer double-click vs. single-click.
;Menu, tray, add  ; Creates a separator line.
Menu, tray, add, Options, EditHotkeys
;Menu, tray, add, Pause/Unpause, mgr_ToggleRButtonState
Menu, tray, add
Menu, tray, add, Suspend mouse gestures, SuspendGestures
Menu, tray, add, Suspend hotkeys, SuspendHotkeys
Menu, tray, add, Reload, Reload
Menu, tray, add
Menu, tray, add, About, About
Menu, tray, add, Check for updates, CheckUpdate
Menu, tray, add, Exit, Exit
Menu, Tray, Default, Options 

#Include, lib-custom\Com.ahk
;#Include, lib-custom\URLEncode.lib.ahk
#Include, lib-custom\TuncayIni.lib.ahk
#Include, mgr\Init.ahk
#Include, lib-custom\VolumeOSD.init.lib.ahk
#Include, mgr\LexMain.ahk

if (UseSpeechRecognition and !IsEditing)
{
  #Include, lib-custom\SpeechRecognition.lib.ahk
}

;Hotkey, ~MButton & RButton, mgr_ToggleRButtonState
;mgr_SetRButtonHotkey("mgr_MonitorRButton")

Return

#Include, mgr\LexFunctions.ahk
#Include, mgr\R3gxFunctions.ahk
#Include, commands\Main.ahk
#Include, common\Functions.ahk
#Include, mgr\MenuItems.ahk
#Include, lib-custom\ExplorerFunc.lib.ahk
#Include, lib-custom\Updater.lib.ahk
#Include, lib-custom\TTS.lib.ahk
#Include, lib-custom\GoogleTTS.lib.ahk
;#Include, lib-custom\eval.lib.ahk