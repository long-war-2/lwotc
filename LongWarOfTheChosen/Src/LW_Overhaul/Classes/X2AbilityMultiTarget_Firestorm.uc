//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityMultiTarget_Firestorm.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class X2AbilityMultiTarget_Firestorm extends X2AbilityMultiTarget_Radius;

var array<AbilityGrantedBonusRadius> RadiusMultipliers;

function AddRadiusMultiplier(name AbilityName = '', float RadiusMult = 1.0f)
{
    local AbilityGrantedBonusRadius Bonus;

    if (RadiusMult == 1.0f)
        return;

    Bonus.RequiredAbility = AbilityName;
    Bonus.fBonusRadius = RadiusMult;

    RadiusMultipliers.AddItem(Bonus);
}

simulated function float GetTargetRadius(const XComGameState_Ability Ability)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        SourceUnit;
    local AbilityGrantedBonusRadius RadiusMultiplier;
    local float                     TotalMultiplier;
    local float                     Radius;

    Radius = super.GetTargetRadius(Ability);

    History = `XCOMHISTORY;

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    if (SourceUnit != none)
    {
        TotalMultiplier = 1.0f;
        foreach RadiusMultipliers(RadiusMultiplier)
        {
            if (RadiusMultiplier.RequiredAbility == '' || SourceUnit.HasSoldierAbility(RadiusMultiplier.RequiredAbility, true))
            {
                TotalMultiplier += (RadiusMultiplier.fBonusRadius - 1.0f);
            }
        }
        TotalMultiplier = FMax(TotalMultiplier, 0.0f);
        Radius *= TotalMultiplier;
    }

    return Radius;
}
