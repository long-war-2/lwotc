interface MCM_API_Spinner extends MCM_API_Setting;

function string GetValue();
function SetValue(string Selection, bool SuppressEvent);
function SetOptions(array<string> NewOptions, string InitialSelection, bool SuppressEvent);