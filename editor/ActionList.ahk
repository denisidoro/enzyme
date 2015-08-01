Voice := ComObjCreate("SAPI.SpVoice")
Voices := TTS(Voice, "GetVoices")
StringReplace, Voices, Voices, `n, `,%A_Space%, All

ProfilesComma := Substr(Profiles, 1, -1)
StringReplace, ProfilesComma, ProfilesComma, |, `,%A_Space%, All

FileRead, ActionList, resource\actions.ini

SectionNames := ini_getAllSectionNames(ActionList)

AddActionTemplate("Select an action here", "")

Loop, Parse, SectionNames, `,
{

  desc := ini_getValue(ActionList, A_LoopField, "desc",, 1)
  code := ini_getValue(ActionList, A_LoopField, "code",, 1)
  group := ini_getValue(ActionList, A_LoopField, "group",, 1)
  
  if (group != lastgroup and group != "")
  {
    groupname := group " related"
    StringUpper, groupname, groupname
    AddActionTemplate(" ", "")
    AddActionTemplate(groupname, "")
  }
      
  if (group != "")
    lastgroup := group
  
  StringReplace, code, code, ``n, `n, All
  
  AddActionTemplate(desc, code)
  
}
