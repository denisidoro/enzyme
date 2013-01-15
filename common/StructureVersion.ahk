Version_Number := 1.80
ThisStructureVersion = 1.70

about_version = Version %Version_Number%

if (isEditing)
  about_version = %about_version% [Main]`nVersion 1.60 [Editor]

StructureVersion := FindStructureVersion()

;Msgbox, %StructureVersion%, %ThisStructureVersion%, %IsUpgrading%, %IsEditing%
if (StructureVersion != ThisStructureVersion and !IsUpgrading)
{

  MsgBox,, %Script_Name%, Your config files are not up to date`nUpgrade tool will be executed`n`nApp version: %ThisStructureVersion%`nConfig files version: %StructureVersion%
  Run Editor.exe forceUpgrade,,UseErrorLevel
  ExitApp

}

FindStructureVersion()
{

  ;SettingsFileURL := "profiles\Settings.ini"
  Global SettingsFileURL

  if !FileExist(SettingsFileURL)
    StructureVersion = 0
    
  else
  {

    FileRead, Settings, % SettingsFileURL

    StructureVersion := ini_getValue(Settings, "About", "StructureVersion",, 1)

    if (StructureVersion = "")
      StructureVersion = 0.8

  }
  
  return StructureVersion

}