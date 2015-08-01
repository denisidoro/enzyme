;-----------------------------------------------------------------
; FUNCTIONS ------------------------------------------------------
;-----------------------------------------------------------------

; Checks if the user has selected 'start with Windows' during installation
CheckStartWindows()
{
  
  Global SettingsFileURL, ThisStructureVersion
  FileRead, Settings, % SettingsFileURL
  
  InFile := A_ScriptDir . "\Enzyme.exe"
  OutFile=%A_Startup%\Enzyme.lnk
  StartWithWindows := (FileExist(OutFile)) ? 1 : 0
  
  ini_replaceValue(Settings, "Windows", "StartWithWindows", StartWithWindows)
  ini_save(Settings, SettingsFileURL)

}

; Deletes Enzyme Editor shortcut from public startup folder
DeleteEditorShortcut() 
{
  OutFile=%A_StartupCommon%\Enzyme Editor.lnk
  if FileExist(OutFile)
    FileDelete, %OutFile%  
  OutFile=%A_StartupCommon%\Enzyme.lnk
  if FileExist(OutFile)
    FileDelete, %OutFile%
}

; Deletes Enzyme Editor old executable
DeleteEnzymeEditor() 
{
  OutFile:="Enzyme Editor.exe"
  if FileExist(OutFile)
    FileDelete, %OutFile%  
}

; Corrects key name change
ReplaceGestureWithTrigger() 
{

  Global CommandsFileURL
  FileRead, Commands, % CommandsFileURL
  StringReplace, Commands, Commands, GestureName, TriggerName, All  
  ini_save(Commands, CommandsFileURL)

}

AddActiveProfile()
{

  Global SettingsFileURL, ThisStructureVersion
  FileRead, Settings, % SettingsFileURL
  if (!ini_getValue(Settings, "Profile", "Active"))
    Settings .= "`n`n[Profile]`nActive=Default"
  ini_save(Settings, SettingsFileURL)
  
}

; Deletes temp folder
DeleteTempFolder()
{

  FileRemoveDir, temp, 1

}

; Replaces Files
ReplaceSettingsFile()
{
  FileCopy, temp\Settings.ini, profiles\, 1
}
ReplaceCommandsFile()
{
  FileCopy, temp\Commands.ini, profiles\default\, 1
}
ReplaceConditionGroupsFile()
{
  FileCopy, temp\ConditionGroups.ini, profiles\default\, 1
}

; Update structure version
UpdateStructureVersion() 
{

  Global SettingsFileURL, ThisStructureVersion
  FileRead, Settings, % SettingsFileURL
  ini_replaceValue(Settings, "About", "StructureVersion", ThisStructureVersion)
  ini_save(Settings, SettingsFileURL)

}


;-----------------------------------------------------------------
; QUESTION -------------------------------------------------------
;-----------------------------------------------------------------

AskOkDeleteFiles()
{

  MsgBox, 4, %Script_Name%, It seems that previous Enzyme versions have generated unnecessary file shortcuts and executables. Is it OK to delete them?
  
  if MsgBox Yes
    OkDeleteFiles = 1
  else
    OkDeleteFiles = 0
    
  return OkDeleteFiles
      
}

AskOkReplaceSettings()
{
  
  MsgBox, 4, %Script_Name%, It appears that your settings file isn't compatible with this Enzyme version. Is it OK to replace your file with a blank one? Sorry for that!
  
  IfMsgBox Yes
    OkReplaceSettings = 1
  else
    OkReplaceSettings = 0
    
  return OkReplaceSettings 
    
}

AskOkDoTweaks()
{

  MsgBox, 4, %Script_Name%, It seems that your commands file needs some changes in order to be compatible with this Enzyme version. Is it OK to do some tweaks in your file?
  
  IfMsgBox Yes
    OkDoTweaks = 1
  else
    OkDoTweaks = 0
    
  return OkDoTweaks
    
}