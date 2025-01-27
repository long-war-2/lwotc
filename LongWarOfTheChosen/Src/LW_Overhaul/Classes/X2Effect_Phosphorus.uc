// Improved version of effect from Merist

class X2Effect_Phosphorus extends X2Effect_Persistent config(LW_SoldierSkills);

var config int BONUS_CV_SHRED;
var config int BONUS_MG_SHRED;
var config int BONUS_BM_SHRED;

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local XComGameStateHistory History;
    local XComGameState_Item SourceWeapon;
    local name AbilityName;
    local bool bShouldApply;

    History = `XCOMHISTORY;

    SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AppliedData.ItemStateObjectRef.ObjectID));

    if (AbilityState == none)
        return 0;

    if (Attacker.HasSoldierAbility('PhosphorusPassive'))
    {
        AbilityName = AbilityState.GetMyTemplateName();
        if (class'OPTC_Phosphorus'.default.PhosphorusAbilities.Find(AbilityName) != INDEX_NONE)
        {
            bShouldApply = true;
        }
        else
        {
            switch (AbilityName)
            {
                case 'LWFlamethrower':
                case 'Roust':
                case 'Firestorm':
                case 'FirestormActivation':
                case 'AdvPurifierFlamethrower':
                    bShouldApply = true;
                    break;
                default:
                    break;
            }
        }
        if (bShouldApply)
        {
            switch(X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponTech)
            {
                case 'conventional':
				case 'laser_lw':
					return default.BONUS_CV_SHRED;
                case 'magnetic':
				case 'coilgun_lw':
					return default.BONUS_MG_SHRED;
                case 'beam':
					return default.BONUS_BM_SHRED;
                default:
					return default.BONUS_CV_SHRED;
					break;
            }
        }
    }
    return 0;
}
