Version_Number := 1.70
ThisStructureVersion = 1.70

if (!isEditing)
  about_version = Version %Version_Number%
else
  about_version = Version 1.5.5 [Editor]

StructureVersion := FindStructureVersion()

;Msgbox, %StructureVersion%, %ThisStructureVersion%, %IsUpgrading%, %IsEditing%
if (StructureVersion != ThisStructureVersion and !IsUpgrading)
{

  ;Msgbox, %StructureVersion%, %ThisStructureVersion%
  MsgBox,, %Script_Name%, Your config files are not up to date`nUpgrade tool will be executed
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