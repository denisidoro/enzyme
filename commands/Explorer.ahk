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
return ; done!g