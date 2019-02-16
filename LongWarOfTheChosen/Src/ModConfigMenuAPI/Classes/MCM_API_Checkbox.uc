interface MCM_API_Checkbox extends MCM_API_Setting;

function bool GetValue();
function SetValue(bool Checked, bool SuppressEvent);