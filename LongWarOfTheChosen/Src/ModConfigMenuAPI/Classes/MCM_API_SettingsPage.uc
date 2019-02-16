interface MCM_API_SettingsPage;

delegate SaveStateHandler(MCM_API_SettingsPage SettingsPage);

// Gives you a way to uniquely identify this settings page from all others, 
// guaranteed to be unique per "OnInit" of the mod settings menu.
function int GetPageId();

function SetPageTitle(string title);

// Use these to handle user triggered save/cancel events.
function SetSaveHandler(delegate<SaveStateHandler> SaveHandler);
function SetCancelHandler(delegate<SaveStateHandler> CancelHandler);

// By default Reset button is not visible, you can choose to use it.
function EnableResetButton(delegate<SaveStateHandler> ResetHandler);

// Groups let you visually cluster settings. All settings belong to groups.
function MCM_API_SettingsGroup AddGroup(name GroupName, string GroupLabel);
function MCM_API_SettingsGroup GetGroupByName(name GroupName);
function MCM_API_SettingsGroup GetGroupByIndex(int Index);
function int GetGroupCount();

// Call to indicate "done making settings". Must call all of your AddGroup and Group.Add#### calls before this.
function ShowSettings();