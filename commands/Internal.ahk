Wait(msec)
{
  Sleep msec
}

CallMsgBox(msg)
{
  MsgBox, %msg%
}

GetCurrentKeyState:
  status := GetKeyState(A_ThisHotkey, "T")
  status := (status = 1) ? "ON" : "OFF"
  status = You have just pressed %A_ThisHotkey%`nIt's current status is %status%
  ShowTrayTip(status)
  ;SendInput, % "{" A_ThisHotkey "}"
return

ToggleStates(mouseState, hotkeyState)
{

  if mouseState
    Gosub, SuspendGestures
  if hotkeyState
    Gosub, SuspendHotkeys

}

ReloadApp()
{
  Reload
}
    
ChangeProfile(newProfile)
{
  Global
  FileRead, Settings, % SettingsFileURL
  ini_replaceValue(Settings, "Profile", "Active", newProfile)
  ;Msgbox, %Settings%
  SaveInis()
  Reload
}

/*
TestingArguments(vStr, vNum, vChar, vDef=33, vDef2="default", vNum2=1)
{
  Msgbox, Inside function:`n%vStr%, %vNum%, %vChar%, %vDef%, %vDef2%, %vNum2%
}
*/