//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_CloseandPersonal
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up range-based crit modifier for Close and Personal perk
//--------------------------------------------------------------------------------------- 

class X2Effect_CloseandPersonal extends X2Effect_Persistent config (LW_SoldierSkills);

var config array<int> CRITBOOST;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local int Tiles;
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if(SourceWeapon != none)
    {
        Tiles = Attacker.TileDistanceBetween(Target);       
        if(CRITBOOST.Length > 0)
        {
            if(Tiles < CRITBOOST.Length)
            {
                ShotInfo.Value = CRITBOOST[Tiles];
            }            
            else //Use last value
            {
                ShotInfo.Value = CRITBOOST[CRITBOOST.Length - 1];
            }
            ShotInfo.ModType = eHit_Crit;
            ShotInfo.Reason = FriendlyName;
            ShotModifiers.AddItem(ShotInfo);
        }
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="CloseandPersonal"
}