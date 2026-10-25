//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityMultiTarget_Flamethrower.uc
//  AUTHOR:  Merist | Based on the original class by Amineri (Pavonis Interactive)
//---------------------------------------------------------------------------------------
class X2AbilityMultiTarget_Flamethrower extends X2AbilityMultiTarget_Cone_LWFlamethrower;

var array<AbilityGrantedBonusCone>  ConeSizeMultipliers;

function AddBonusConeSizeMultiplier(name AbilityName = '', float DiameterMult = 1.0f, float LengthMult = 1.0f)
{
    local AbilityGrantedBonusCone BonusCone;

    if (DiameterMult == 1.0f && LengthMult == 1.0f)
        return;

    BonusCone.RequiredAbility = AbilityName;
    BonusCone.fBonusDiameter = DiameterMult;
    BonusCone.fBonusLength = LengthMult;

    ConeSizeMultipliers.AddItem(BonusCone);
}

function float GetConeLength(const XComGameState_Ability Ability)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        SourceUnit;
    local AbilityGrantedBonusCone   ConeMultiplier;
    local float                     TotalMultiplier;
    local float                     Length;
    local EffectConeSizeModifier	SizeModifier;
    local EffectConeSizeMultiplier	SizeMultiplier;

    Length = super(X2AbilityMultiTarget_Cone).GetConeLength(Ability);

    History = `XCOMHISTORY;

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    if (SourceUnit != none)
    {
        foreach EffectConeSizeModifiers(SizeModifier)
        {
            if (SizeModifier.RequiredEffectName == 'none' || SourceUnit.AppliedEffectNames.Find(SizeModifier.RequiredEffectName) != INDEX_NONE)
            {
                Length += SizeModifier.ConeRangeModifier;
            }
        }
        TotalMultiplier = 1.0f;
        foreach ConeSizeMultipliers(ConeMultiplier)
        {
            if (ConeMultiplier.RequiredAbility == 'none' || SourceUnit.HasSoldierAbility(ConeMultiplier.RequiredAbility, true))
            {
                TotalMultiplier += (ConeMultiplier.fBonusLength - 1.0f);
            }
        }
        foreach EffectConeSizeMultipliers(SizeMultiplier)
        {
            if (SizeMultiplier.RequiredEffectName == 'none' || SourceUnit.AppliedEffectNames.Find(SizeMultiplier.RequiredEffectName) != INDEX_NONE)
            {
                TotalMultiplier += (SizeMultiplier.ConeRangeMultiplier - 1.0f);
            }
        }
        TotalMultiplier = FMax(TotalMultiplier, 0.0f);
        Length *= TotalMultiplier;
    }

    `LOG(GetFuncName() @ Ability.GetMyTemplateName $ Length, class'X2Action_Fire_Flamethrower_LW'.default.bLog, default.Class.Name);
    return Length;
}

function float GetConeEndDiameter(const XComGameState_Ability Ability)
{
    local XComGameStateHistory      History;
    local XComGameState_Item        SourceWeapon;
    local X2WeaponTemplate          WeaponTemplate;
    local XComGameState_Unit        SourceUnit;
    local AbilityGrantedBonusCone   BonusCone, ConeMultiplier;
    local float                     TotalMultiplier;
    local float                     Diameter;
    local EffectConeSizeModifier	SizeModifier;
    local EffectConeSizeMultiplier	SizeMultiplier;

    Diameter = super(X2AbilityMultiTarget_Cone).GetConeEndDiameter(Ability);

    if (bUseWeaponRadius)
    {
        SourceWeapon = Ability.GetSourceWeapon();
        if (SourceWeapon != none)
        {
            WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            if (WeaponTemplate != none)
            {
                Diameter = WeaponTemplate.iRadius * class'XComWorldData'.const.WORLD_StepSize;
            }
        }
    }

    History = `XCOMHISTORY;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    if (SourceUnit != none)
    {
        foreach EffectConeSizeModifiers(SizeModifier)
        {
            if (SizeModifier.RequiredEffectName == 'none' || SourceUnit.AppliedEffectNames.Find(SizeModifier.RequiredEffectName) != INDEX_NONE)
            {
                Diameter += SizeModifier.ConeRadiusModifier;
            }
        }
        foreach AbilityBonusCones(BonusCone)
        {
            if (BonusCone.RequiredAbility == 'none' || SourceUnit.HasSoldierAbility(BonusCone.RequiredAbility, true))
            {
                Diameter += BonusCone.fBonusDiameter;
            }
        }

        TotalMultiplier = 1.0f;
        foreach ConeSizeMultipliers(ConeMultiplier)
        {
            if (ConeMultiplier.RequiredAbility == 'none' || SourceUnit.HasSoldierAbility(ConeMultiplier.RequiredAbility, true))
            {
                TotalMultiplier += (ConeMultiplier.fBonusDiameter - 1.0f);
            }
        }
        foreach EffectConeSizeMultipliers(SizeMultiplier)
        {
            if (SizeMultiplier.RequiredEffectName == 'none' || SourceUnit.AppliedEffectNames.Find(SizeMultiplier.RequiredEffectName) != INDEX_NONE)
            {
                TotalMultiplier += (SizeMultiplier.ConeRadiusMultiplier - 1.0f);
            }
        }
        TotalMultiplier = FMax(TotalMultiplier, 0.0f);
        Diameter *= TotalMultiplier;
    }

    `LOG(GetFuncName() @ Ability.GetMyTemplateName $ Diameter, class'X2Action_Fire_Flamethrower_LW'.default.bLog, default.Class.Name);
    return Diameter;
}

simulated function UpdateParameters(XComGameState_Ability Ability);

defaultproperties
{
    bUseWeaponRadius = true
    bUseWeaponRangeForLength = true
}