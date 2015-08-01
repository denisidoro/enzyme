/*
  Lex' Mouse Gestures
  by Lexikos (Steve Gray)
*/

/*
 * Configuration Defaults:
 *      Override these in Gestures_User.ahk (in the "Gestures:" sub).
 */

;MsgBox, IsEditing0: %IsEditing%

; mgr\Init.ahk reads all parameters from Settings.ini

/*
 * Basic global init
 */

/*
#NoEnv
#SingleInstance Force       ; Never allow more than one instance of this script.
CoordMode, Mouse, Screen    ; Let mouse commands use absolute/screen co-ordinates.
SendMode Input              ; Set recommended send-mode.
SetTitleMatchMode, 2        ; Match anywhere in window title.
SetWorkingDir %A_ScriptDir% ; Set working directory to script's directory for consistency.
SetBatchLines, -1           ; May improve responsiveness. Shouldn't negatively affect other
                            ; apps as the script sleeps every %m_Interval% ms while active.
*/
CoordMode, Mouse, Screen    ; Let mouse commands use absolute/screen co-ordinates.
SendMode Input              ; Set recommended send-mode.

/*
 * Set text labels to be used in other areas
 */

; Zone labels used when four zones are active:
c_Zone4_0 = R
c_Zone4_1 = D
c_Zone4_2 = L
c_Zone4_3 = U

; Zone labels used when eight zones are active:
c_Zone8_0 = R
c_Zone8_1 = DR
c_Zone8_2 = D
c_Zone8_3 = DL
c_Zone8_4 = L
c_Zone8_5 = UL
c_Zone8_6 = U
c_Zone8_7 = UR


/*
 * Load configuration
 */

; Run "auto-execute" sections of Gestures_Default.ahk and Gestures_User.ahk, in that order.
; Explicit labels are required in case the file contains only gesture definitions or hotkeys.

/*
if IsLabel(ErrorLevel:="DefaultGestures")
    gosub %ErrorLevel%

if IsLabel(ErrorLevel:="Gestures")
    gosub %ErrorLevel%
*/

/*
 * Initialize script - don't mess with this unless you know what you're doing
 */
 
if (!IsEditing)
  G_SetTrayIcon(true)         ; Set custom tray icon (also called by ToggleGestureSuspend).

; Hook "Suspend Hotkeys" messages to update the tray icon.
; Note: This has the odd side-effect of "disabling" the tray menu
;       if the script is paused from the tray menu.
OnMessage(0x111, "WM_COMMAND")

/*
; Set tooltip for tray icon.
Menu, Tray, Tip, Mouse Gestures
; Setup custom tray menu.
Menu, Tray, NoStandard
Menu, Tray, Add, &Open      , TrayMenu_Open
Menu, Tray, Add, &Help      , TrayMenu_Help
Menu, Tray, Add
Menu, Tray, Add, &Reload    , TrayMenu_Reload
Menu, Tray, Add, &Suspend   , TrayMenu_Suspend
Menu, Tray, Add
Menu, Tray, Add, Edit &Gestures.ahk         , TrayMenu_Edit

Menu, Tray, Add, Edit Gestures_&Default.ahk , TrayMenu_Edit
Menu, Tray, Add, Edit Gestures_&User.ahk    , TrayMenu_Edit
Menu, Tray, Add
Menu, Tray, Add, E&xit      , TrayMenu_Exit
Menu, Tray, Default, &Open
*/

; Create a group for easy identification of Windows Explorer windows.
GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Explorer, ahk_class ExploreWClass

; Some code relies on m_InitialZoneCount being set.
if m_InitialZoneCount < 2
    m_InitialZoneCount := m_ZoneCount

; The following are relied on by the script and should not be changed:
c_PI := 3.141592653589793, c_Degrees := 180/c_PI

m_WaitForRelease := false   ; Are we waiting for the gesture key to be released? Not yet.
m_PassKeyUp := false        ; Should GestureKey_Up pass key-release to the active window? Not yet.
m_ClosingWindow := 0        ; We aren't about to close any window.

; Set up the canvas for mouse-trails, if configured.
;if m_PenWidth && !IsEditing
if m_PenWidth
;if !m_PenWidth
{
    ; Set default trail colour or convert RRGGBB to 0xBBGGRR.
    if m_PenColor =
        m_PenColor := 0
    else
        m_PenColor := "0x" . SubStr(m_PenColor,5,2) . SubStr(m_PenColor,3,2) . SubStr(m_PenColor,1,2)
       
    m_PenColor &= 0xffffff
    ; Use any other colour as the trail-Gui background.
    m_TransColor := m_PenColor ? "000000" : "FFFFFF"

    ; Create the Gui if not already created, and set it as the Last Found Window.
    Gui, 2: +LastFound
    ; Make the Gui background transparent.
    Gui, 2: Color, %m_TransColor%
    WinSet, TransColor, %m_TransColor%
    ; Remove the caption and borders, and hide the Gui from the taskbar.
    ;Gui, 2: -Caption +ToolWindow +AlwaysOnTop
    Gui, 2: -Caption +ToolWindow +AlwaysOnTop
    ; Get the HWND and HDC of the Last Found Window (the Gui).
    hw_canvas := WinExist()
    hdc_canvas := DllCall("GetDC", "uint", hw_canvas)
    ; Create the pen, if not already created.
    pen := DllCall("CreatePen", "int", 0, "int", m_PenWidth, "uint", m_PenColor)
    ; Select the pen and store a handle to the previously selected pen (common GDI practice).
    old_pen := DllCall("SelectObject", "uint", hdc_canvas, "uint", pen)
    ; Create a brush for erasing the Gui background.
    brush := DllCall("CreateSolidBrush", "uint", "0x" m_TransColor)
    
    brush2 := DllCall("CreateSolidBrush", "uint", m_PenColor)
    old_brush := DllCall("SelectObject", "uint", hdc_canvas, "uint", brush2)
}

; Register hotkeys.
G_ToggleGestureKeyState()

SoundPlay, %m_EnabledSound%

if m_KeylessPrefix {
    if !m_ActiveTimeout
        if m_Timeout
            m_ActiveTimeout := m_Timeout
        else
            m_ActiveTimeout := 1000
    SetTimer, GestureKeyless, %m_Interval%  ; Won't run while in the gesture recognition loop.
}

if (m_InitialState = 0 and !IsEditing)
  GoSub, SuspendGestures