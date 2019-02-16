interface MCM_API_Slider extends MCM_API_Setting;

delegate string SliderValueDisplayFilter(float value);

function float GetValue();
function SetValue(float Value, bool SuppressEvent);
function SetBounds(float min, float max, float step, float newValue, bool SuppressEvent);

function SetValueDisplayFilter(delegate<SliderValueDisplayFilter> Filter);