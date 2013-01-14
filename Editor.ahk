Loop, %0%  ; For each parameter:
{
  param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
  if (param = "forceUpgrade")
  {
    forceUpgrade := true
    break
  }
}

isUpgrading := false
isEditing := true

if forceUpgrade
  isUpgrading := True
else
  isEditing := true

#include, common\FileLocations.ahk
#Include, common\StructureVersion.ahk

#include, editor\EditorGUI.ahk
#include, upgrade\Upgrade.ahk

return

#Include, lib-custom\Com.ahk
#Include, mgr\LexFunctions.ahk
#Include, editor\Functions.ahk
#Include, editor\GUILabels.ahk
#Include, editor\MenuItems.ahk
#Include, mgr\MenuItems.ahk
#Include, common\Functions.ahk
#Include, lib-custom\TuncayIni.lib.ahk
#Include, lib-custom\LVG.lib.ahk
#Include, mgr\R3gxFunctions.ahk
#Include, lib-custom\JoystickTest.lib.ahk
#Include, lib-custom\Zip.lib.ahk
#Include, lib-custom\TTS.lib.ahk
#Include, lib-custom\Updater.lib.ahk

;^F1::reload