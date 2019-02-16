interface MCM_API_Setting;

enum eSettingType
{
    eSettingType_Label,
    eSettingType_Button,
    eSettingType_Checkbox,
    eSettingType_Slider,
    eSettingType_Dropdown,
    eSettingType_Spinner,
    eSettingType_Unknown
};

// Name is used for ID purposes, not for UI.
function name GetName();

// Label is used for UI purposes, not for ID.
function SetLabel(string NewLabel);
function string GetLabel();

// When you mouse-over the setting.
function SetHoverTooltip(string Tooltip);
function string GetHoverTooltip();

// Lets you show an option but disable it because it shouldn't be configurable.
// For example, if you don't want to allow tweaking during a mission.
function SetEditable(bool IsEditable);

// Retrieves underlying setting type. Defined as an int to make setting types more extensible to support
// future "extension types".
function int GetSettingType();

// Returns the group that the setting belongs to.
function MCM_API_SettingsGroup GetParentGroup();
