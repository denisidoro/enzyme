SettingsFileURL := "profiles\Settings.ini"

FileRead, Settings, % SettingsFileURL
ActiveProfile := ini_GetValue(Settings, "Profile", "Active")

if (!FileExist("profiles\" ActiveProfile "\Commands.ini"))
  ActiveProfile := "default"

CommandsFileURL := "profiles\" ActiveProfile "\Commands.ini"
GroupsFileURL := "profiles\" ActiveProfile "\ConditionGroups.ini"