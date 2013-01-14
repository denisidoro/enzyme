if (!isEditing)
	creditsH := 160
else
	creditsH := 80

Gui, Add, Picture, x122 y30 w140 h150 , resource\test-tube.png
Gui, Add, Link, x15 y40, <a href="https://github.com/denisidoro/enzyme/">Source code on Github</a>
Gui, Add, Link, y+5, <a href="http://catalysisapps.wordpress.com/contact/">Contact</a>
Gui, Add, Link, y+5, <a href="http://www.youtube.com/watch?feature=player_embedded&v=cdyPXe3pUas">Video tutorial</a>
Gui, Font, S15 CDefault Bold, Verdana
Gui, Add, Text, x132 y190 w250 h50 , Enzyme
Gui, Font, S10 CDefault Italic, Verdana
Gui, Add, Text, x22 y220 w400 h30 , Hastes processes. Maintains the equilibrium.
Gui, Font, S6 CDefault Italic, Verdana
;Gui, Add, Text, x280 y40 w400 h30 , %about_version%
Gui, Font, S8 CDefault Norm, Verdana
Gui, Add, Edit, x22 y255 w350 h%creditsH% , %about_version%`n`nThis application is open-source`nFeel free to send me suggestions or update the code%about_infoText%`n`nSome bits of code were of great value, helping me understand how to do things or partially integrating this software, with modifications. Here they are:`n`nR3gX's MGR`nhttp://www.autohotkey.com/forum/topic71666.html`n`nLex's Mouse Gestures`nhttp://www.autohotkey.com/forum/topic25892.html`n`nLukewarm's GUI`nhttp://lukewarm.s101.xrea.com/`n`nILAN12346's gTTS`nhttp://de.autohotkey.com/forum/viewtopic.php?t=8210`n`nAce_NoOne's TimeAnnouce`nhttp://www.autohotkey.com/forum/topic14305.html`n`nRseding's Self Script Updater`nhttp://www.autohotkey.net/~Rseding91/Self%20Script%20Updater/Self%20Script%20Updater.ahk
