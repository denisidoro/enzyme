CallNirCmd(argument)
{

  AppLocation := "external/nircmd/nircmd.exe"
  
  if !FileExist(AppLocation)
  {
    Msgbox, 4, Enzyme can't do this by itself..., This action needs a third-party software: NirCmd by NirSoft`nYou can download it at http://www.nirsoft.net/utils/nircmd.html`nAfter downloading, extract its files to <Enzyme's directory>/external/nircmd/`nDo you want to be redirected to this site?
    IfMsgBox, Yes
     Run, http://www.nirsoft.net/utils/nircmd.html
    return
  }
  
  Run, %AppLocation% %argument%,, Hide|UseErrorLevel 

}

CallOrzTimer()
{

  AppLocation := "external/orztimer/Orzeszek Timer.exe"
  
  if !FileExist(AppLocation)
  {
    Msgbox, 4, Enzyme can't do this by itself..., This action needs a third-party software: Orzeszek Timer by OrzeszekDevelopment`nYou can download it at http://www.orzeszek.org/dev/timer/`nAfter downloading, extract its files to <Enzyme's directory>/external/orztimer/`nDo you want to be redirected to this site?
    IfMsgBox, Yes
     Run, http://www.orzeszek.org/dev/timer/
    return
  }
      
  InputBox, argument, Input timer arguments, Check Orzeszek Timer's webpage for help,,, 250, 120 
  Run, %AppLocation% %argument%,, Hide|UseErrorLevel 

}

RunCertainProgram(AppLocation, option)
{

  if AppLocation = "" 
    AppLocation := A_WinDir "\System32\Notepad.exe"
  ;else
  ;  if InStr(AppLocation, """")
  ;    AppLocation := Substr(AppLocation, 2, -1)
    
  ;if (!option)
  ; option := 0
    
  if option = 0  
    path := Explorer_GetSelected()
  else if option = 1
    path := Explorer_GetAll()
  else if option = 2
    path := Explorer_GetPath()
  
  ;CRASH ON DESKTOP
  ;msgbox, %path%
  ;return
  
  if path = ERROR
  {
    Run, "%AppLocation%"
    return
  }
    
  Loop, Parse, path, `n
    Run, "%AppLocation%" "%A_LoopField%"

}
