;====================================================================================================================
;Functions===========================================================================================================
;====================================================================================================================

isFullScreen()
{
  ScWidth  = %A_ScreenWidth%
  ScHeight = %A_ScreenHeight%
  WinGetClass Class, A
  WinGetPos,,,W,H, A
  If ( Class <> "Progman" and Class <> "WorkerW" )
    If ( A_ScreenWidth <> ScWidth  or  A_ScreenHeight <> ScHeight
    or ( W > ScWidth - 9  and  H > ScHeight- 9) )
      fullscreen=1
  Return fullscreen
}

Increase_Volume(amount)
{
  volume_level := VA_GetMasterVolume()
  volume_level += %amount%
  VA_SetMasterVolume(volume_level)
  Gosub, Volume_Bar_Update
}


;====================================================================================================================
;Labels---===========================================================================================================
;====================================================================================================================

Loops_From_Update:
volume_level := VA_GetMasterVolume()
SetTimer, Volume_Bar_Hide, off
Loop %volume_level%
{
GuiControl,30: Hide, BE%A_Index%
GuiControl,30: Show, BF%A_Index%
}
volume_level2 := 100 - volume_level
Loop %volume_level2%
{
index := 101 - A_Index
GuiControl,30: Hide, BF%index%
GuiControl,30: Show, BE%index%
}
return

Volume_Bar_Update:
if isFullScreen() or %bugMeNot%
return
Gosub, Loops_From_Update
;return

Volume_Bar_Update2:
if isFullScreen() or %bugMeNot%
  return
if VA_GetMasterMute()
  {
  GuiControl,30: Show, MuteOn
  GuiCOntrol,30: Hide, MuteOff
  }
else
  {
  GuiControl,30: Show, MuteOff
  GuiCOntrol,30: Hide, MuteOn
  }
gosub, Show_Background
Gui, 30: Show, xCenter yCenter w602 h95
SetTimer, Volume_Bar_Hide, %Visible_Duration%
return
Volume_Bar_Hide:
SetTimer, Volume_Bar_Hide, off
Gui, 30: Hide
Gui, 29: Hide
Background_Vis=0
return

Show_Background:
If %Background_Vis%
return
Gui, 29: Show, xCenter yCenter w602 h95
Background_Vis=1
return

Volume_Bar_Click:
Gui_Bar_To_Volume=% A_GuiControl
StringTrimLeft, volume_level, Gui_Bar_To_Volume, 2
VA_SetMasterVolume(volume_level)
Gosub, Volume_Bar_Update
return

Mute_On_Off:
if VA_GetMasterMute()
  {
  VA_SetMasterMute(false)
  Gosub, Volume_Bar_Update2
  }
else
  {
  VA_SetMasterMute(true)
  Gosub, Volume_Bar_Update2
  }
Gosub, Volume_Bar_Update
return


;====================================================================================================================
;MAIN FUNCTION ======================================================================================================
;====================================================================================================================

ChangeVolumeWithOSD(amount=0)
{

  if amount = 0
    Gosub, Mute_On_Off
  else
    Increase_Volume(amount)

}