class X2Effect_HuntersInstinctDamage_LW extends X2Effect_HuntersInstinctDamage;

var bool bMatchSourceWeapon;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Unit                TargetUnit;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local XComGameState_Item                SourceWeapon;
    local GameRulesCache_VisibilityInfo     VisInfo;

    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (TargetUnit != none)
    {
        // Don't apply to melee attacks, grenades and indirect fire
        StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
        if (StandardAim == none || StandardAim.bMeleeAttack || StandardAim.bIndirectFire)
        {
            return 0;
        }

        if (class'X2Effect_BonusRocketDamage_LW'.default.VALID_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE
            || AbilityState.GetMyTemplateName() == 'MicroMissiles')
        {
            return 0;
        }

        // Don't apply to damage-over-time
        if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        {
            return 0;
        }

        // Apply only to source weapon if attached, or the primary weapon if not.
        if (bMatchSourceWeapon)
        {
            SourceWeapon = AbilityState.GetSourceWeapon();
            if (SourceWeapon != none)
            {
                if (EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID == 0)
                {
                    if (SourceWeapon.InventorySlot != eInvSlot_PrimaryWeapon)
                    {
                        return 0;
                    }
                }
                else
                {
                    if (SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
                    {
                        return 0;
                    }
                }
            }
            else
            {
                return 0;
            }
        }

        if (Attacker.CanFlank() && TargetUnit.GetMyTemplate().bCanTakeCover)
        {
            if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, TargetUnit.ObjectID, VisInfo))
            {
                if (VisInfo.TargetCover == CT_None || TargetUnit.GetCurrentStat(eStat_AlertLevel) == 0 && TargetUnit.GetTeam() != eTeam_XCom)
                {
                    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
                    {
                        if (CurrentDamage > 0)
                        {
                            return BonusDamage;
                        }
                    }
                }
            }
        }
    }

    return 0;
}