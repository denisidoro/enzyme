if !FileExist(SettingsFileURL) or !FileExist(CommandsFileURL) or !FileExist(GroupsFileURL)
{
  ;Msgbox, % SettingsFileURL ", " CommandsFileURL ", " GroupsFileURL
  MsgBox, Your config files are corrupted or this is your first time running Enzyme`nUpgrade tool will be executed
  Run Editor.exe forceUpgrade,,UseErrorLevel
  ExitApp
}

; Read all variables in the settings INI file

SectionNames := ini_getAllSectionNames(Settings)

Loop, Parse, SectionNames, `,
{
  ThisSectionName := A_LoopField
  KeyNames := ini_getAllKeyNames(Settings, ThisSectionName)
  Loop, Parse, KeyNames, `,
  {
    VariableName := A_LoopField
    if ThisSectionName = Mouse
      VariableName := "m_" . VariableName
    %VariableName% := ini_getValue(Settings, ThisSectionName, A_LoopField,, 1)
  }
}

SectionNames := KeyNames := ThisSectionName := VariableName := "" 

if (StoreINIFiles or IsEditing)
{
  FileRead, Groups, % GroupsFileURL
  FileRead, Commands, % CommandsFileURL
}

else
{
  Settings := ""
} 

mgr_ToggleHotkeysState() ;From off (uninitialized) to on