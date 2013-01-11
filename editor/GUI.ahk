ActionDelimiterEdit := "`n"

;Gui, Add, Button, x3 y345 w130 h23 , &Import from Clipboard
Gui, Add, Button, x165 y345 w64 h23 , &OK
Gui, Add, Button, x235 y345 w64 h23 , &Apply
Gui, Add, Button, x303 y345 w64 h23 , &Cancel

Gui, Add, Tab, x2 y0 w420 h400 , Start|Triggers|Actions|Conditions|Options|About

Gui, Tab, Start
Gui, Add, Picture, x22 y30 w75 h75 , resource\mouse.png
Gui, Add, Picture, x22 y120 w75 h75 , resource\mixer.png
Gui, Add, Picture, x22 y210 w75 h75 , resource\window-group.png
Gui, Font, S10 CDefault Bold
Gui, Add, Text, x125 y50 w230 h45 , 1) Create a new trigger from mouse, keyboard and others
Gui, Add, Text, x125 y135 w230 h45 , 2) Associate a command to this new trigger
Gui, Add, Text, x125 y225 w230 h45 , 3) Customize conditionals and options
Gui, Font, S8 CDefault Norm
Gui, Add, Text, gGiveSomeHelp x25 y300 w330 h35 , Se você está tendo dificuldades ao usar o programa, clique aqui para ver um arquivo de ajuda

Gui, Tab, Actions
;Gui, Add, Button, gAddAction x15 y25 w20 h20 , +
;Gui, Add, Button, gDeleteAction x35 y25 w20 h20 , -
;Gui, Add, Button, x55 y25 w20 h20 , C
;Gui, Add, Button, gActionGoUp x75 y25 w20 h20 , ↑
;Gui, Add, Button, gActionGoDown x95 y25 w20 h20 , ↓
Gui, Add, ListBox, vMyListBox1 gUpdateListView1 x15 y47 w100 h277 AltSubmit,
Gui, Add, ListView, gUpdateCommandControls vMyListView1 x123 y36 w220 h110 NoSort AltSubmit -Multi, Condition|Action|Name
Gui, Add, Button, gConditionGoUp vUpButton1 x344 y36 w20 h20 , ↑
Gui, Add, Button, gConditionDelete vMinusButton1 x344 y81 w20 h20 , -
Gui, Add, Button, gConditionGoDown vDownButton1 x344 y126 w20 h20 , ↓
Gui, Add, Text, x125 y160 w48 h13 , &Condition
Gui, Add, DropDownList, vMyDropDown1 x173 y156 w88 AltSubmit,
Gui, Add, Button, gAddNewActionCommand vMyButton1 x263 y156 w31 h20 , Add
Gui, Add, Button, gUpdateActionCommand vMyButton12 x296 y156 w47 h20 , Update
Gui, Add, Text, x125 y185 w40 h13 , &Name
Gui, Add, Edit, vMyEdit12 x165 y182 w178 h21 ,
Gui, Add, Edit, vMyEdit13 x123 y212 w220 h86 ,
Gui, Add, Button, gClearCode x344 y246 w20 h20 , -
Gui, Add, DropDownList, vMyDropDown12 x123 y302 w188 AltSubmit
Gui, Add, Button, gAddActionText x313 y302 w31 h20 , Add
Gui, Add, GroupBox, x12 y10 w70 h0 , GroupBox
Gui, Add, Button, x502 y140 w160 h110 , Button

Gui, Tab, Triggers
Gui, Add, Button, gAddHotkey x15 y25 w20 h20 , +
Gui, Add, Button, gDeleteHotkey vMinusButton2 x35 y25 w20 h20 , -
;Gui, Add, Button, x55 y25 w20 h20 , C
Gui, Add, Button, gHotkeyGoUp vUpButton2 x75 y25 w20 h20 , ↑
Gui, Add, Button, gHotKeyGoDown vDownButton2 x95 y25 w20 h20 , ↓
Gui, Add, ListBox, gUpdateNameHK vMyListBox2 x15 y47 w100 h277 AltSubmit, 
Gui, Add, Text, x125 y50 w40 h13 , &Name
Gui, Add, Edit, vMyEdit2 x165 y46 w126 h21 , 
Gui, Add, Button, gChangeCommandName vMyButton2 x293 y46 w50 h20 , Update
;Gui, Add, Edit, gGiveCommandName vMyEdit22 x123 y71 w170 h20 , 
Gui, Add, Edit, gGiveCommandName vMyEdit22 x123 y71 w220 h20 , 
;Gui, Add, Button, gUpdateHotkey x296 y71 w47 h20 , Update
;Gui, Add, Text, x125 y100 w250 h13 , Don't forget to hit Change and Update
Gui, Font, Underline
Gui, Add, Text, x125 y115 w50 h13 , &Keyboard
Gui, Font, Norm
Gui, Add, Hotkey, x180 y110 w140 gOnHotkeyChange vGuiHotkey, %hotkey%
Gui, Font, Underline
Gui, Add, Text, x125 y150 w50 h13 , &Joystick
Gui, Font, Norm
Gui, Add, Edit, x180 y145 w140 gOnJoystickChange vMyEdit23
Gui, Font, Underline
Gui, Add, Text, x125 y185 w50 h13 , &Speech
Gui, Font, Norm
Gui, Add, Edit, x180 y180 w140 gOnSpeechChange vMyEdit24
Gui, Add, Button, gKeyHelp x325 y110 w20 h20 , ?
Gui, Add, Button, gJoyHelp x325 y150 w20 h20 , ?
Gui, Add, Button, gSpeechHelp x325 y180 w20 h20 , ?
Gui, Font, Underline
Gui, Add, Text, x125 y218 w50 h13 , &Mouse
Gui, Font, Norm
Gui, Add, Text, x125 y245 w250 h90 , In order to record a mouse gesture, just simulate it in this window (try dragging the middle mouse button to some directions)
/*
Gui, Add, Button, gHK1 x123 y193 w24 h24 , ↖
Gui, Add, Button, gHK2 x148 y193 w24 h24 , ↑
Gui, Add, Button, gHK3 x173 y193 w24 h24 , ↗
Gui, Add, Button, gHK4 x123 y219 w24 h24 , ←
Gui, Add, Button, gHK5 x148 y219 w24 h24 , x
Gui, Add, Button, gHK6 x173 y219 w24 h24 , →
Gui, Add, Button, gHK7 x123 y245 w24 h24 , ↙
Gui, Add, Button, gHK8 x148 y245 w24 h24 , ↓
Gui, Add, Button, gHK9 x173 y245 w24 h24 , ↘
Gui, Add, Button, gShowInfoSimulation x123 y285 w73 h36 , Use simulated gesture
Gui, Add, Text, x220 y300 w130 h30 , Left mouse button only works with modifiers
Gui, Add, ListBox, gUpdateMouseButtons vMyListBox22 x208 y171 w132 h121 AltSubmit, %MButtons%
;Gui, Add, Button, x208 y296 w132 h20 , Any Button Up
*/

Gui, Tab, Conditions
Gui, Add, Button, x15 y25 w20 h20 gAddGroup, +
Gui, Add, Button, x35 y25 w20 h20 gDeleteGroup vMinusButton3, -
Gui, Add, Button, x75 y25 w20 h20 gGroupGoUp vUpButton3, ↑
Gui, Add, Button, x95 y25 w20 h20 gGroupGoDown vDownButton3, ↓
Gui, Add, ListBox, x15 y46 w100 h277 gUpdateListView3 vMyListBox3 AltSubmit, 
Gui, Add, Text, x125 y50 w40 h13 , &Name
Gui, Add, Edit, x165 y46 w126 h21 vMyEdit3, 
Gui, Add, Button, x293 y46 w50 h20 gChangeConditionName vMyButton30, Change
Gui, Add, ListView, x123 y70 w220 h145 gUpdateDropEdit3 vMyListView3 NoSort AltSubmit -Multi, Type|Condition Value
Gui, Add, Button, x344 y135 w20 h20 gDeleteConditionDef vMyButton3, -
Gui, Add, DropDownList, x123 y227 w138 vMyDropDown3 AltSubmit, Match any rule|Match all rules
Gui, Add, Button, x263 y227 w31 h20 gAddConditionGroup vMyButton32, Add
Gui, Add, Button, x296 y227 w47 h20 gUpdateConditionGroup vMyButton33, Update
Gui, Add, Text, x125 y255 w40 h13 , &Type
Gui, Add, DropDownList, x165 y252 w179 vMyDropDown32 Choose1 AltSubmit, %CTypes% ;y276
Gui, Add, DropDownList, x165 y276 w179 vMyDropDown33 Choose1 AltSubmit, Inclusion|Exclusion
Gui, Add, Button, x325 y300 w20 h20 gHelperAction, ?
Gui, Add, Text, x125 y304 w40 h13 , &Value
Gui, Add, Edit, x165 y300 w157 h21 vMyEdit32,

Gui, Tab, Options
Gui, Add, CheckBox, x22 y40 w220 h20 Checked%StartWithWindows% vMyCheckBox4, Start with Windows?
Gui, Add, CheckBox, x22 y+5 w220 h20 Checked%StoreINIFiles% vMyCheckBox41, Store INI files in memory?
Gui, Add, CheckBox, x22 y+5 w260 h20 Checked%UseSpeechRecognition% vMyCheckBox43, Use speech recognition?
Gui, Add, Text, x22 y145, Profile
Gui, Add, DropDownList, x22 y160 Choose%ActiveProfileIndex% vMyDropDown4 gUpdateActiveProfile, %Profiles%
Gui, Add, Button, x+5 y160 gImportProfile, Import
Gui, Add, Button, x+5 y160 gExportProfile, Export
Gui, Add, Button, x+5 y160 gGetMoreProfiles, Get more
Gui, Add, Button, x22 y+30 gEditAdvSettings, Advanced settings
Gui, Add, Button, x22 y+30 gExecuteUpgrade, Upgrade tool
Gui, Add, Button, x+5 gCheckUpdate, Check for updates
/*
Gui, Add, CheckBox, x22 y130 w260 h20 Checked%ForceDefaultCommand% vMyCheckBox42, Force default commands for LButton and RButton?
;Gui, Add, Text, x22 y130 w260 h20 , Monitor which mouse combinations?
Gui, Add, Text, x140 y170 w110 h20 , Alone
Gui, Add, Text, x190 y170 w90 h20 , Ctrl
Gui, Add, Text, x235 y170 w90 h20 , Alt
Gui, Add, Text, x280 y170 w90 h20 , Shift
Gui, Add, Text, x325 y170 w90 h20 , Win
Gui, Add, Text, x22 y195 w130 h20 , Left mouse button
Gui, Add, CheckBox, Checked%CheckedMCCheckBox1% vMCCheckBox1 x150 y190
Gui, Add, CheckBox, Checked%CheckedMCCheckBox2% vMCCheckBox2 x195 y190
Gui, Add, CheckBox, Checked%CheckedMCCheckBox3% vMCCheckBox3 x240 y190
Gui, Add, CheckBox, Checked%CheckedMCCheckBox4% vMCCheckBox4 x285 y190
Gui, Add, CheckBox, Checked%CheckedMCCheckBox5% vMCCheckBox5 x330 y190
Gui, Add, Text, x22 y220 w130 h20 , Middle mouse button
Gui, Add, CheckBox, Checked%CheckedMCCheckBox6% vMCCheckBox6 x150 y220
Gui, Add, CheckBox, Checked%CheckedMCCheckBox7% vMCCheckBox7 x195 y220
Gui, Add, CheckBox, Checked%CheckedMCCheckBox8% vMCCheckBox8 x240 y220
Gui, Add, CheckBox, Checked%CheckedMCCheckBox9% vMCCheckBox9 x285 y220
Gui, Add, CheckBox, Checked%CheckedMCCheckBox10% vMCCheckBox10 x330 y220
Gui, Add, Text, x22 y245 w130 h20 , Right mouse button
Gui, Add, CheckBox, Checked%CheckedMCCheckBox11% vMCCheckBox11 x150 y250
Gui, Add, CheckBox, Checked%CheckedMCCheckBox12% vMCCheckBox12 x195 y250
Gui, Add, CheckBox, Checked%CheckedMCCheckBox13% vMCCheckBox13 x240 y250
Gui, Add, CheckBox, Checked%CheckedMCCheckBox14% vMCCheckBox14 x285 y250
Gui, Add, CheckBox, Checked%CheckedMCCheckBox15% vMCCheckBox15 x330 y250
Gui, Add, Text, x22 y295 w130 h20 , &Minimal distance
Gui, Add, Edit, vMyEdit4 x120 y290 w126 h21, %MinimalDistance%
*/

Gui, Tab, About
about_infoText = 
#Include, common\About.ahk

; Generated using SmartGUI Creator 4.0
Gui, Show, h373 w388, Enzyme :: Editor
;Gui, Submit, NoHide