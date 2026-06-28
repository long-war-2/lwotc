class X2Effect_FocusedDefense extends X2Effect_Persistent;

var int DefenseBonus;
var int DodgeBonus;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

    if (!bFlanking && !bMelee && !bIndirectFire)
    {
        if (IsClosestVisibleEnemy(Target, Attacker))
        {
            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = -1 * DefenseBonus;
            ShotModifiers.AddItem(ShotInfo);

            ShotInfo.ModType = eHit_Graze;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = DodgeBonus;
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}
// Return `true` if TargetUnit is the closest visible enemy for SourceUnit
static function bool IsClosestVisibleEnemy(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit)
{
    local XComGameStateHistory          History;
    local array<StateObjectReference>   VisibleUnits;
    local StateObjectReference          UnitRef;
    local XComGameState_Unit            VisibleUnit;
    local int                           TargetDistance;
    
    History = `XCOMHISTORY;

    TargetDistance = SourceUnit.TileDistanceBetween(TargetUnit);

    class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(SourceUnit.ObjectID, VisibleUnits);
    class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(SourceUnit.ObjectID, VisibleUnits);

    if (VisibleUnits.Find('ObjectID', TargetUnit.ObjectID) == INDEX_NONE)
    {
        return false;
    }

    foreach VisibleUnits(UnitRef)
    {
        VisibleUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

        if (SourceUnit.TileDistanceBetween(VisibleUnit) < TargetDistance)
        {
            return false;
        }
    }

    return true;
}