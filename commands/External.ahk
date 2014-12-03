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

CallWinPad(argument)
{

  AppLocation := "external/winpad/WindowPadX.exe"
  
  if !FileExist(AppLocation)
  {
    Msgbox, 4, Enzyme can't do this by itself..., This action needs a third-party software: WindowPadX`nYou can download it at https://github.com/hoppfrosch/WindowPadX/releases`nAfter downloading, extract its files to <Enzyme's directory>/external/winpad/`nDo you want to be redirected to this site?
    IfMsgBox, Yes
     Run, https://github.com/hoppfrosch/WindowPadX/releases
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