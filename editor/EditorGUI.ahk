if IsEditing
{

SetWorkingDir, %A_ScriptDir%

Menu, Tray, Icon, Shell32.dll, 99
#NoTrayIcon 

process, close, Enzyme.ahk
process, close, Enzyme.exe

Script_Name := "Enzyme :: Editor" ;Your script name
LocationURL := "common\FileLocations.ahk"

;IsEditing = true

#Include, mgr\Init.ahk
#Include, mgr\LexMain.ahk
#Include, editor\Main.ahk

}