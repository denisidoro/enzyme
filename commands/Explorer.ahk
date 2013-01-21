; TOGGLES FILE EXTENSIONS
ToggleFileExtensions:
  RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, (HiddenFiles_Status = 1) ? 0 : 1
  send, {F5}
return
  
  
; TOGGLES HIDDEN FILES
ToggleHiddenFiles:
  RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
  RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, (HiddenFiles_Status = 2) ? 1 : 2
  send, {F5}
return

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

NextDesktopBackground:
  winActivate, ahk_class Progman
  MouseGetPos, xpos, ypos ; get current mouse position
  Click 0,0 ; click in the corner of the desktop, to unselect any selected iconSend 
  Send, +{F10} ; send Shift+F10, the shortcut for right-click
  Send, {n} ; send "n", the key for "next desktop background"
  Click %xpos%, %ypos%, 0 ; put the mouse back at its previous position
return ; done!

RunCertainProgram(AppLocation, option)
{

  if AppLocation = "" 
    AppLocation := A_WinDir "\System32\Notepad.exe"
  ;else
  ;  if InStr(AppLocation, """")
  ;    AppLocation := Substr(AppLocation, 2, -1)
    
  ;if (!option)
  ; option := 0
    
  if option = 0  
    path := Explorer_GetSelected()
  else if option = 1
    path := Explorer_GetAll()
  else if option = 2
    path := Explorer_GetPath()
  
  ;CRASH ON DESKTOP
  ;msgbox, %path%
  ;return
  
  if path = ERROR
  {
    Run, "%AppLocation%"
    return
  }
    
  Loop, Parse, path, `n
    Run, "%AppLocation%" "%A_LoopField%"

}

CreateNewFile()
{

  path := Explorer_GetPath()

  FileAppend,, %path%\Newfile.txt

}