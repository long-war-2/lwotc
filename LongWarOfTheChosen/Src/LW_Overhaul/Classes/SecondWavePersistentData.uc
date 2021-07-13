//---------------------------------------------------------------------------------------
//  FILE:    SecondWavePersistentData.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Binds the second wave options to an INI file.
//--------------------------------------------------------------------------------------- 

class SecondWavePersistentData extends Object config(LW_SecondWaveData);

struct PersistentSecondWaveOption
{
    var name ID;
    var bool IsChecked;
};

var config bool IsDifficultySet;
var config int Difficulty;
var config bool DisableBeginnerVO;
var config array<PersistentSecondWaveOption> SecondWaveOptionList;
