interface MCM_API_SettingsGroup;

delegate VoidSettingHandler(MCM_API_Setting Setting);
delegate BoolSettingHandler(MCM_API_Setting Setting, bool SettingValue);
delegate FloatSettingHandler(MCM_API_Setting Setting, float SettingValue);
delegate StringSettingHandler(MCM_API_Setting Setting, string SettingValue);

// For reference purposes, not display purposes.
function name GetName();

// For display purposes, not reference purposes.
function string GetLabel();
function SetLabel(string Label);

function MCM_API_SettingsPage GetParentPage();

// Will return None if setting by that name isn't found.
function MCM_API_Setting GetSettingByName(name SettingName);
function MCM_API_Setting GetSettingByIndex(int Index);
function int GetNumberOfSettings();

// It's done this way because of some UI issues where dropdowns don't behave unless you initialize
// the settings UI widgets from bottom up.
function MCM_API_Label AddLabel(name SettingName, string Label, string Tooltip);
function MCM_API_Button AddButton(name SettingName, string Label, string Tooltip, string ButtonLabel, 
    optional delegate<VoidSettingHandler> ClickHandler);
function MCM_API_Checkbox AddCheckbox(name SettingName, string Label, string Tooltip, bool InitiallyChecked, 
    optional delegate<BoolSettingHandler> SaveHandler, 
    optional delegate<BoolSettingHandler> ChangeHandler);
function MCM_API_Slider AddSlider(name SettingName, string Label, string Tooltip, float SliderMin, float SliderMax, float SliderStep, float InitialValue, 
    optional delegate<FloatSettingHandler> SaveHandler, 
    optional delegate<FloatSettingHandler> ChangeHandler);
function MCM_API_Spinner AddSpinner(name SettingName, string Label, string Tooltip, array<string> Options, string Selection, 
    optional delegate<StringSettingHandler> SaveHandler, 
    optional delegate<StringSettingHandler> ChangeHandler);
function MCM_API_Dropdown AddDropdown(name SettingName, string Label, string Tooltip, array<string> Options, string Selection, 
    optional delegate<StringSettingHandler> SaveHandler, 
    optional delegate<StringSettingHandler> ChangeHandler);