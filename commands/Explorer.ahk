GetSelectedText() {
   tmp = %ClipboardAll% ; save clipboard
   Clipboard := "" ; clear clipboard
   Send, ^c ; simulate Ctrl+C (=selection in clipboard)
   ClipWait, 1 ; wait until clipboard contains data
   selection = %Clipboard% ; save the content of the clipboard
   Clipboard = %tmp% ; restore old content of the clipboard
   return selection
}

; TOGGLES FILE EXTENSIONS
ToggleFileExtensions:
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
	If HiddenFiles_Status = 1
	    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
	Else
	    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
	Send, {F5}
return
  
; TOGGLES HIDDEN FILES
ToggleHiddenFiles:
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
	If HiddenFiles_Status = 2
	    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
	Else
	    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
	Send, {F5}
Return

; EXECUTE SHELL COMMAND
ExecuteShellCommand:
	path := Explorer_GetPath()
	;MsgBox, %path%
	InputBox, command, Command, Insert a bash command, , 640, 150
	RunWait, C:\Programs\Cygwin\bin\bash.exe -c "cd $(cygpath %path%); %command%;"
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

ToggleDesktopIcons:
    ControlGet, HWND, Hwnd,, SysListView321, ahk_class Progman
    If HWND =
        ControlGet, HWND, Hwnd,, SysListView321, ahk_class WorkerW
    If DllCall("IsWindowVisible", UInt, HWND)
        WinHide, ahk_id %HWND%
    Else
        WinShow, ahk_id %HWND%
return

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

CreateNewFile(option, content)
{

  path := Explorer_GetPath()

  if path = ERROR
    return

  if option = 0
    InputBox, filename, Filename, Please include the extension, , 640, 150
  else if option = 1
    filename := "newfile.txt"
  else
    filename := option

  content := (content = 0) ? "" : content
    
  FileAppend, %content%, %path%\%filename%

}