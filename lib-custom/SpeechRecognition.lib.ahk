COM_init()

pspeaker := ComObjCreate("SAPI.SpVoice")

if UseNativeVoiceCommands
  plistener := ComObjCreate("SAPI.SpSharedRecognizer")

else
{
  plistener:= ComObjCreate("SAPI.SpInprocRecognizer")
  paudioinputs := plistener.GetAudioInputs()
  plistener.AudioInput := paudioinputs.Item(0)
}

ObjRelease(paudioinputs) ; Release object from memory, it is not needed anymore.
pcontext := plistener.CreateRecoContext()
pgrammar := pcontext.CreateGrammar()
pgrammar.DictationSetState(0)
prules := pgrammar.Rules()
prulec := prules.Add("wordsRule", 0x1|0x20)
prulec.Clear()
pstate := prulec.InitialState()

; Add here the words to be recognized! Looks like it understands the null pointer.
mgr_InitAllHKCommands(1)

prules.Commit()
pgrammar.CmdSetRuleState("wordsRule", 1)
prules.Commit()
ComObjConnect(pcontext, "On")

/*
If (pspeaker && plistener && pcontext && pgrammar && prules && prulec && pstate)
   {   
   
   pspeaker.speak("Voice recognition initialisation succeeded. Available voice commands:")
   MsgBox, Available Voice recognition initialisation succeeded. Available Voice Commands:`nAccounting`nFinances
   
   }
Else
{
 pspeaker.speak("Starting voice recognition initialisation failed")
 MsgBox, Starting voice recognition initialisation failed
}
*/

OnRecognition(StreamNum,StreamPos,RecogType,Result)
{
      
   Global pspeaker, VoiceCommandsString

   ; Grab the text we just spoke and go to that subroutine
   pphrase := Result.PhraseInfo()
   sText := pphrase.GetText()
   
    mgr_Execute(mgr_GetCommand("SP_" . sText, IsFromMouse=0, ReturnDescription=1))
   
   ObjRelease(pphrase) ;release object from memory
   ObjRelease(sText)
   
}