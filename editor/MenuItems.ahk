ButtonOk:
CheckSettings()
SaveInis()
Run Enzyme.exe,,UseErrorLevel
Run Enzyme.ahk,,UseErrorLevel
ExitApp

ButtonApply:
CheckSettings()
SaveInis()
return

ButtonCancel:
GuiClose:
if StartOnExit
  Run Enzyme.exe,,UseErrorLevel
ExitApp