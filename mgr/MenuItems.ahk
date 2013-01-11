Exit:
  ExitApp
return

CleanUp:
  if !IsEditing
  {
    COM_Release(pevent)
    COM_Release(pstate)
    COM_Release(prulec)
    COM_Release(prules)
    COM_Release(pgrammar)
    COM_Release(pcontext)
    COM_Release(plistener)
    COM_Term()
    ExitApp
  }
return

Reload:
  Reload
return

About:
  about_infoText = 
  #Include, common\About.ahk
  Gui, Show, h373 w388, About
  check_forupdate()
return

SuspendHotkeys:
  if % !mgr_ToggleHotkeysState() {
      Menu, Tray, Check, Suspend hotkeys
      SoundPlay, %m_DisabledSound%
  } 
  else {
      Menu, Tray, Uncheck, Suspend hotkeys
      SoundPlay, %m_EnabledSound%
  }
return

SuspendGestures:
  if % !G_ToggleGestureKeyState() {
      Menu, Tray, Check, Suspend mouse gestures
      SoundPlay, %m_DisabledSound%
      G_SetTrayIcon(false)
  } 
  else {
      Menu, Tray, Uncheck, Suspend mouse gestures
      SoundPlay, %m_EnabledSound%
      G_SetTrayIcon(true)
  }
return

CheckUpdate:
  check_forupdate()
return

EditHotkeys:
  Run "Editor.exe", %A_WorkingDir%, UseErrorLevel
  ExitApp
return