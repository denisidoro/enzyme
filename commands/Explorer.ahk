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
	RunWait, C:\Programs\Cygwin\bin\bash.exe -c "cd $(/usr/bin/cygpath %path%); %command%;"
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

MoveWindowToDesktop(next) {

   ; Launch Win+Tab and open context menu
   Send, #{Tab}
   Sleep, 150
   Send, {AppsKey}

   ; Get context menu info
   WinWait, ahk_class #32768
   SendMessage, 0x1E1, 0, 0
   hMenu := ErrorLevel
   sContents := GetMenu(hMenu)
   StringSplit, itemArray, sContents, `, 

   ; Determine what is the current desktop as well as the total number of desktops
   total := 1
   current := 0
   Loop, %itemArray0%
   {
      element := itemArray%A_Index%
      StringSplit, wordArray, element, %A_Space%
      lastWord := wordArray%wordArray0%
      if (lastWord+0) {
         if (lastWord > total and current = 0)
            current := lastWord - 1
         total := total + 1
      }
      else if (current > 0)
         break
   }
   if (current = 0)
      current := total

   if ((current = total and next = 1) or (current = 1 and next = 0)) {
      Sleep, 75
      SendInput, {Esc 2}
      return
   }

   else {

      ; Send input to select desired desktop
      desired := current - 2 + next
      SendInput, {Down}
      SendInput, {Right}
      SendInput, {Down %desired%}
      SendInput, {Enter}

      ; Go to desired desktop
      SendInput, {Enter}
      if (next = 1)
         Send, ^#{Right}
      else
         Send, ^#{Left}

   }

   return

}