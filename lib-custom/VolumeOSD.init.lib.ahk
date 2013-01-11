;====================================================================================================================
;Options ============================================================================================================
;====================================================================================================================
;Volume_Increments_general = 2		;Volume increments for keyboard default "Vol+" "Vol-" keys
Visible_Duration = 1800			;Duration of Volume Control display (milliseconds)
;Holding_Duration = 750  ;Time needed holding MMB in order to show OSD


;====================================================================================================================
;Startup ============================================================================================================
;====================================================================================================================
#Include, lib-custom\VA.lib.ahk
Volume_Increments = %Volume_Increments_general%
Gui 31: show, hide, Volume Control - message receiver


;====================================================================================================================
;Volume OSD Background ==============================================================================================
;====================================================================================================================
Gui, 29: +AlwaysOnTop +ToolWindow -caption +LastFound
WinSet, Region, 0-0 W602 H59
Gui, 29: Color, FFFF00
Gui, 29: Add, Picture, w602 h59 x0 y0, %A_ScriptDir%\resource\VolumeOSD\Background.png
WinSet, TransColor, FFFF00 255
Gosub, Loops_From_Update

;====================================================================================================================
;Volume OSD Bars and Speakers =======================================================================================
;====================================================================================================================
Gui, 30: +AlwaysOnTop +ToolWindow -caption +LastFound
WinSet, Region, 0-0 W602 H59
Gui, 30: Color, FFFF00
WinSet, TransColor, FFFF00 255
Gui, 30: Add, Picture, w81 h59 x0 y0 gMute_On_Off vMuteOff, %A_ScriptDir%\resource\VolumeOSD\SpeakerSound.png
Gui, 30: Add, Picture, w81 h59 x0 y0 gMute_On_Off vMuteOn, %A_ScriptDir%\resource\VolumeOSD\SpeakerMute.png
startp = 83
Loop 100
	{
	Gui, 30: Add, Picture, vBF%A_Index% w5 h31 x%startp% y15 gVolume_Bar_Click, %A_ScriptDir%\resource\VolumeOSD\Full.png
	Gui, 30: Add, Picture, vBE%A_Index% w5 h31 x%startp% y15 gVolume_Bar_Click, %A_ScriptDir%\resource\VolumeOSD\Empty.png
	startp += 5
	}