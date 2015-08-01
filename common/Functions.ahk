; SHOWS A TRAYTIP
ShowTrayTip(txt, secs=4, tipTitle="")
{ 

   Global 
   
   if !tipTitle
    tipTitle = %Script_Name%

   If (txt = "")
   {  ; remove traytip
      TrayTip
      Return
   }
   
   If ( secs >= 1 AND secs <= 20 )
      msecs := secs * 1000
   Else
      msecs = 5000
	  
   TrayTip, %tipTitle%, %txt%, 20, 17 ; nopopupsound+info
   SetTimer, f_TTRemoveTrayTip, %msecs%
   Return
   
   f_TTRemoveTrayTip:
      SetTimer, f_TTRemoveTrayTip, Off
      TrayTip
      Return
      
}

Run(path, RunWait=0, options="UseErrorLevel", msg="Error occurred!", WorkingDir="")
{
	If !path
		Return
	
	; Trim  white chars and delete ending backslash
	path := RegExReplace(path, "(^\s*|\s*$)")
	path := RegExReplace(path ,"\\*$")

	; Set default options if they aren't valid
	If !msg
		msg := "Error occurred!"
	If !RegExMatch(options, "(Max|Min|Hide|UseErrorLevel)")
		options := "UseErrorLevel"
	If (InStr(FileExist(path), "D"))	; If the path is a directory shortcut,
		options .= "|Max"				;	open it maximized
	RunWait			:= RunWait ? 1 : 0
	; Ensure to have a valid directory path for WorkingDir
	WorkingDir	:= InStr(FileExist(WorkingDir), "D") ? WorkingDir : A_ScriptDir
	
	If RunWait {
		RunWait, %path%, %WorkingDir%, %options%, OutputVarPID
		If ErrorLevel
			MsgBox, %msg%
	}Else{
		Run, %path%,%WorkingDir%, %options%, OutputVarPID
		If ErrorLevel
			MsgBox, %msg%
	}
	Return, OutputVarPID
}

SaveInis(suffix="")
{
  Global
  Name = %CommandsFileURL%%suffix%
  ini_save(Commands, Name)
  Name = %GroupsFileURL%%suffix%
  ini_save(Groups, Name)
  Name = %SettingsFileURL%%suffix%
  ini_save(Settings, Name)
}

GetMenu(hMenu)
{
   Loop, % DllCall("GetMenuItemCount", "Uint", hMenu)
   {
      idx := A_Index - 1
      idn := DllCall("GetMenuItemID", "Uint", hMenu, "int", idx)
      nSize++ := DllCall("GetMenuString", "Uint", hMenu, "int", idx, "Uint", 0, "int", 0, "Uint", 0x400)
	  nSize := (nSize * (A_IsUnicode ? 2 : 1))
      VarSetCapacity(sString, nSize)
      DllCall("GetMenuString", "Uint", hMenu, "int", idx, "str", sString, "int", nSize, "Uint", 0x400)   ;MF_BYPOSITION
      If !sString
         sString := "---------------------------------------"
      ;sContents .= idx . " : " . idn . A_Tab . A_Tab . sString . "`n"
      sContents .= sString . ","
      If (idn = -1) && (hSubMenu := DllCall("GetSubMenu", "Uint", hMenu, "int", idx))
         sContents .= GetMenu(hSubMenu)
   }
   Return   sContents
}