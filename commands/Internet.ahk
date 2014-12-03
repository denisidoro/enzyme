;Search selected text on search engine
SearchWebsite(url)
{
  if url = g
    url = http://www.google.com/search?q=
  else if url = w
    url = http://en.wikipedia.org/wiki/Special:Search?search=
  Sleep 50
  Run, % url . GetSelectedText()
}

ShortenURL(method)
{

  Send, ^c
  longURL = %clipboard%
  
  ;if (!InStr(longURL, "http://"))
  ;  longURL = http://%longURL%
  
  ShowTrayTip("Shortening URL...`n" . longURL)
  
  ; Goo.gl
  
  if method = 2
  {
  
    ;global API_G
    
    API_G = AIzaSyBDqyjONOz2lWr7tsgBZF5ZghJSGYrOolY
    
    http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
    main:="https://www.googleapis.com/urlshortener/v1/url"
    params:="?key=" API_G
    http.open("POST", main . params, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.send("{""longURL"": """ longURL """}")
    RegExMatch(http.ResponseText, """id"": ""(.*?)""", match)
    ToReturn := match1  
  
  }

  ; Bit.ly
  else
  {
  
    ;global user, API
    
    user = enzyme
    API = R_92d568b9dece99af944e489c47b811a0
    
    http := ComObjCreate("WinHttp.WinHttpRequest.5.1"), main := "http://api.bit.ly/v3/shorten?"
    longURL := urlEncode(longURL) ; Need urlEncode function
    post := "format=txt&login=" user "&apiKey=" API "&longURL=" longURL
    http.open("GET", main . post, false)
    http.send()
    ToReturn := RegexReplace(http.ResponseText, "\r?\n?")  
  
  }
  
  ShowTrayTip("")
  Clipboard := ToReturn
  ShowTrayTip("Url shortened and copied to clipboard!`n" . ToReturn)
  
}

urlEncode(url){
  f = %A_FormatInteger%
  SetFormat, Integer, Hex
  While (RegexMatch(url,"\W", var))
      StringReplace, url, url, %var%, % asc(var), All
  StringReplace, url, url, 0x, `%, All
  SetFormat, Integer, %f%
  return url
}