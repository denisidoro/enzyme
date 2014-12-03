Win_Minimize()
{
	MouseGetPos,,, WinID
	WinMinimize, ahk_id %WinID%
}

Win_Maximize(){
	MouseGetPos,,, WinID
	WinMaximize, ahk_id %WinID%
}

Win_Close()
{	; Close the whole current window, not the current tab
	MouseGetPos,,, WinID
	WinClose, ahk_id %WinID%
}

SetWinTopMost(action=2)
{
	if action = 0
	WinSet,Topmost,Off
	else if action = 1
	WinSet,Topmost,On
	else if action = 2
	WinSet,Topmost,Toggle
}

Win_AlwaysOnTop(action=2)
{	; Toggle a window between AlwaysOnTop states
	MouseGetPos,,, WinID
	if action = 0
	WinSet, AlwaysOnTop, Off, ahk_id %WinID%
	else if action = 1
	WinSet, AlwaysOnTop, On, ahk_id %WinID%
	else if action = 2 {
		Msgbox, what
		WinGetActiveTitle, t
		WinGet, ExStyle, ExStyle, %t%
		if (ExStyle & 0x8) {
			WinSet, AlwaysOnTop, Off, %t%
			WinSetTitle, %t%,, % RegexReplace(t, " \+")
		}
		else {
			WinSet, AlwaysOnTop, On, %t%
			WinSetTitle, %t%,, %t% +
		}
	}

	SendWinToBottom()
	{
		WinSet,Bottom
	}

	SetWinTransp(value=2, twobutton=1)
	{

		if (!value)
		{  
			WinSet, Transparent, 255, A
			WinSet, Transparent, OFF, A
		}
		
		else
		{
			DetectHiddenWindows, on
			WinGet, curtrans, Transparent, A
			if !curtrans
			curtrans := 255 + value
			newtrans := curtrans - value
			if (newtrans > 255)
			newtrans := twobutton ? 0 : 255
			else if (newtrans < 0)
			newtrans := twobutton ? 255 : 0
			;ShowTrayTip(curTrans ", " newTrans ", " value ", " twobutton)
			WinSet, Transparent, %newtrans%, A
		}
		
	}

	Win_GetClass()
	{	; Get the class of the current window
		TimeLimit	:= 3
		t1			:= A_TickCount
		While (Seconds<TimeLimit){
			Sleep, 10
			t2		:= A_TickCount
			Seconds	:= ((t2-t1)//1000)
			MouseGetPos,,, CurrentWindowID
			WinGetClass, CurrentWinClass, ahk_id %CurrentWindowID%
			ToolTip, % "Window class (" TimeLimit-Seconds "s) : " CurrentWinClass
		}
		Clipboard := CurrentWinClass
		ToolTip
	}

	Win_Last()
	{	; Activate the last window
		IDs := Win_GetList()
		Pos := 1
		While (Pos := RegExMatch(IDs, "[^,]+", m, Pos+StrLen(m)))
		ID%A_Index% := m
		WinActivate, % "ahk_id" ID2
	}

	Win_Next()
	{	; Activate the last window
		IDs := Win_GetList()
		Pos := 1
		While (Pos := RegExMatch(IDs, "[^,]+", m, Pos+StrLen(m)))
		ID%A_Index% := m
		ID := ID3 ? ID3 : ID2
		WinActivate, % "ahk_id" ID
	}

	Win_GetList()
	{
		DetectHiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, Off
		WinGet, ID, List
		Loop, % ID
		{
			ID := ID%A_Index%
			WinGetTitle, Title, ahk_id %ID%
			WinGetClass, Class, ahk_id %ID%
			If Title
			If Title not in Program manager,Startup,Démarrer
			If Class not in tooltips_class32
			IDs .= (IDs ? "," : "") ID
		}
		DetectHiddenWindows, % DetectHiddenWindows
		Return, IDs
	}

	GetWindowGroup()
	{
		output := "This group is: " mgr_GetConditionGroup(true)
		MsgBox %output%
	}