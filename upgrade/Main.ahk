;-----------------------------------------------------------------
; INIT -----------------------------------------------------------
;-----------------------------------------------------------------

HasSelectedNo = 0
OkVars := "DeleteFiles|ReplaceSettings|DoTweaks"
Loop, Parse, OkVars, |
  Ok%A_LoopField% := -1 


;-----------------------------------------------------------------
; QUESTIONS ------------------------------------------------------
;-----------------------------------------------------------------

; Confimation on startup
MsgBox, 4, %Script_Name%, You are now running the Enzyme Upgrade Tool`n`nIt's highly recommended for you to backup all your settings, commands and conditional group files`n`nDo you want to continue? If this is your first time using Enzyme, click 'Yes'
IfMsgBox No
  return

MsgBox, Enzyme new structure version: %ThisStructureVersion%`nEnzyme current structure version: %StructureVersion%
    
; No temp folder
if !FileExist("temp")
{

  MsgBox, Error: couldn't find temp folder`nTry reinstalling Enzyme
  return

}
    
; Same version
if (StructureVersion = ThisStructureVersion)
{
  
  MsgBox, 4, %Script_Name%, It seems that your configuration files are up to date. Do you still want to continue?
  IfMsgBox No
    return

}    
    
else if (StructureVersion = 0)
{

  MsgBox, 4, %Script_Name%, It appears that this is your first time running Enzyme. Is it OK to create some files?
  IfMsgBox Yes
  {
    ReplaceSettingsFile()
    ReplaceCommandsFile()
    ReplaceConditionGroupsFile()
    CheckStartWindows()
  }
  else
  {
    Msgbox, Process can't continue`nClosing application...
    return
  }

}    
    
if StructureVersion between 0.01 and 0.99
{
  
  ; Shortcut
  if (OkDeleteFiles = - 1)
    OkDeleteFiles := AskOkDeleteFiles()
  
  ; SettingsFile
  if (OkReplaceSettings = -1)
    OkReplaceSettings := AskOkReplaceSettings()
 
  ; CommandsFile
  if (OkDoTweaks = -1)
    OkDoTweaks := AskOkDoTweaks()
    
}

if StructureVersion between 1.0 and 1.49
{
    
  ; SettingsFile
  if (OkReplaceSettings = -1)
    OkReplaceSettings := AskOkReplaceSettings()
   
}

if StructureVersion between 1.5 and 1.59
{
    
  if (OkDoTweaks = -1)
    OkDoTweaks := AskOkDoTweaks()

}

if StructureVersion between 1.6 and 1.699
{
  
  if (OkReplaceSettings = -1)
    OkReplaceSettings := AskOkReplaceSettings()
  
}


;-----------------------------------------------------------------
; EXECUTION ------------------------------------------------------
;-----------------------------------------------------------------
  
if OkDeleteFiles
{
  DeleteEditorShortcut()
  DeleteEnzymeEditor()
}
  
if OkDoTweaks
{
  ReplaceGestureWithTrigger()
  AddActiveProfile()
}

if OkReplaceSettings
{
  ReplaceSettingsFile()
  CheckStartWindows()
}
  
Loop, Parse, OkVars, |
{
  if (Ok%A_LoopField% = 0)
  {
    HasSelectedNo = 1
    break
  }
}

if HasSelectedNo
  MsgBox, 0, %Script_Name%, Please note that as you have answered 'No' to a previous question you will now have to manually edit the config files

; Delete temp folder
MsgBox, 4, %Script_Name%, All processes done! You may now delete the temp folder from Enzyme installation directory but if you do so you will only be able to run this upgrade tool after reinstalling Enzyme`n`nDo you still want to delete the temp folder?
IfMsgBox Yes
  DeleteTempFolder()
  
UpdateStructureVersion()