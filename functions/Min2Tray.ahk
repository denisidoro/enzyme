; Minimize Window to Tray Menu
; http://www.autohotkey.com
; This script assigns a hotkey of your choice to hide any window so that
; it becomes an entry at the bottom of the script's tray menu.  Hidden
; windows can then be restored individually or all at once by selecting
; the corresponding item on the menu.  If the script exits for any reason,
; all the windows that it hid will be restored automatically.

; CONFIGURATION SECTION: Change the below values as desired.

; This is the maximum number of windows to allow to be hidden:
mwt_MaxWindows = 50

; This is the hotkey used to hide the active window:
mwt_stack = #h
mwt_unStack = #+h

; If you prefer to have the tray menu empty of all the standard items,
; such as Help and Pause, use N.  Otherwise, use Y:
mwt_StandardMenu = N

; These first few performance settings help to keep the action within
; the #HotkeyModifierTimeout period, and thus avoid the need to release
; and press down the hotkey's modifier if you want to hide more than one
; window in a row.  These settings are not needed you choose to have the
; script use the keyboard hook via #InstallKeybdHook or other means:
#HotkeyModifierTimeout 100
SetWinDelay 10
SetKeyDelay 0

; The below are recommended for this script:
SetBatchLines 10ms
#SingleInstance


; ----------------------------------------------------

Hotkey, %mwt_stack%, mwt_Minimize
Hotkey, %mwt_unStack%, mwt_UnMinimize

; If the user terminates the script by any means, unhide all the
; windows first:
OnExit, mwt_RestoreAllThenExit

if mwt_StandardMenu = Y
  Menu, Tray, Add
else
{
  Menu, Tray, NoStandard
  Menu, Tray, Add, E&xit, mwt_RestoreAllThenExit
}
Menu, Tray, Add, &Restore All Hidden Windows, mwt_RestoreAll
Menu, Tray, Add  ; Another separator to make the above more special.

return  ; End of auto-execute section


mwt_Minimize:
if mwt_WindowCount >= %mwt_MaxWindows%
{
  MsgBox No more than %mwt_MaxWindows% may be hidden simultaneously.
  return
}

WinGet, ActiveID, ID, A
WinGetTitle, ActiveTitle, ahk_id %ActiveID%
; Because hiding the window won't deactivate it, activate the window
; beneath this one (if any). I tried other ways, but they wound up
; activating the task bar.  This way sends the active window (which is
; about to be hidden) to the back of the stack, which seems best:
Send, !{esc}
; Don't hide until after the above, since by default hidden windows are
; not detected:
WinHide, ahk_id %ActiveID%

; In addition to the tray menu requiring that each menu item name be
; unique, it must also be unique so that we can reliably look it up in
; the array when the window is later unhidden.  So make it unique if it
; isn't already:
Loop, %mwt_MaxWindows%
{
  if mwt_WindowTitle%a_index% = %ActiveTitle%
  {
    ; Match found, so it's not unique.
    ; First remove the 0x from the hex number to conserve menu space:
    StringTrimLeft, ActiveIDShort, ActiveID, 2
    StringLen, ActiveIDShortLength, ActiveIDShort
    StringLen, ActiveTitleLength, ActiveTitle
    ActiveTitleLength += %ActiveIDShortLength% ; Add up the new length
    ActiveTitleLength++ ; +1 for room for one space between title & ID.
    if ActiveTitleLength > 100
    {
      ; Since max menu name is 100, trim the title down to allow just
      ; enough room for the Window's Short ID at the end of its name:
      TrimCount = %ActiveTitleLength%
      TrimCount -= 100
      StringTrimRight, ActiveTitle, ActiveTitle, %TrimCount%
    }
    ActiveTitle = %ActiveTitle% %ActiveIDShort%  ; Build unique title.
    break
  }
}

; First, ensure that this ID doesn't already exist in the list, which can
; happen if a particular window was externally unhidden (or its app unhid
; it) and now it's about to be re-hidden:
mwt_AlreadyExists = n
Loop, %mwt_MaxWindows%
{
  if mwt_WindowID%a_index% = %ActiveID%
  {
    mwt_AlreadyExists = y
    break
  }
}

; Add the item to the array and to the menu: ; (and to the window order count)
if mwt_AlreadyExists = n
{
  Menu, Tray, add, %ActiveTitle%, RestoreFromTrayMenu
  mwt_WindowCount++
  Loop, %mwt_MaxWindows%  ; Search for a free slot.
  {
    ; It should always find a free slot if things are designed right.
    if mwt_WindowID%a_index% =  ; An empty slot was found.
    {
      mwt_WindowID%a_index% = %ActiveID%
      mwt_WindowTitle%a_index% = %ActiveTitle%
      mwt_WindowNumber%a_index% = %mwt_WindowCount%
      break
    }
  }
}
return

mwt_UnMinimize:
if mwt_WindowCount = 0
{
  ; Nothing to un hide
  return
}
Loop, %mwt_MaxWindows%
{
  if mwt_WindowID%a_index% <> ; A non-empty slot
  {
    if mwt_WindowNumber%a_index% = %mwt_WindowCount%
    {
      ; This window is the one that needs to be removed
      StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
      WinShow, ahk_id %IDToRestore%
      WinActivate ahk_id %IDToRestore%  ; Sometimes needed.
      StringTrimRight, winTitle, mwt_WindowTitle%a_index%, 0
      Menu, Tray, delete, %winTitle%
      mwt_WindowID%a_index% =  ; Make it blank to free up a slot.
      mwt_WindowTitle%a_index% =
      mwt_WindowCount--
      break
    }
  }
}
return
      

RestoreFromTrayMenu:
Menu, Tray, delete, %A_ThisMenuItem%
; Find window based on its unique title stored as the menu item name:
Loop, %mwt_MaxWindows%
{
  if mwt_WindowTitle%a_index% = %A_ThisMenuItem%  ; Match found.
  {
    StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
    WinShow, ahk_id %IDToRestore%
    WinActivate ahk_id %IDToRestore%  ; Sometimes needed.

    ; Loop through all the windows and decrement what is necessary
    StringTrimRight, winNumber, mwt_WindowNumber%a_index%, 0
    Loop, %mwt_MaxWindows%
    {
      if mwt_WindowNumber%a_index% > %winNumber%
      {
      mwt_WindowNumber%a_index%--
      }
    }

    mwt_WindowID%a_index% =  ; Make it blank to free up a slot.
    mwt_WindowTitle%a_index% =
    mwt_WindowCount--
    break
  }
}
return


mwt_RestoreAllThenExit:
Gosub, mwt_RestoreAll
ExitApp  ; Do a true exit.


mwt_RestoreAll:
Loop, %mwt_MaxWindows%
{
  if mwt_WindowID%a_index% <>
  {
    StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
    WinShow, ahk_id %IDToRestore%
    WinActivate ahk_id %IDToRestore%  ; Sometimes needed.
    ; Do it this way vs. DeleteAll so that the sep. line and first
    ; item are retained:
    StringTrimRight, MenuToRemove, mwt_WindowTitle%a_index%, 0
    Menu, Tray, delete, %MenuToRemove%
    mwt_WindowID%a_index% =  ; Make it blank to free up a slot.
    mwt_WindowTitle%a_index% =
    mwt_WindowCount--
  }
  if mwt_WindowCount = 0
    break
}
return