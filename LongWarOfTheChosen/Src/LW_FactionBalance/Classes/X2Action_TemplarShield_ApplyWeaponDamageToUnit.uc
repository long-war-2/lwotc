class X2Action_TemplarShield_ApplyWeaponDamageToUnit extends X2Action_ApplyWeaponDamageToUnit;

// A version of the Damage Unit action which does not play any animations, and plays a different voiceover if the attack didn't cause HP damage.

simulated function bool ShouldPlayAnimation()
{
	return false;
}

// Same as original, just using different speech when not taking health damage.
simulated state Executing
{
	simulated function ShowDamageMessage(EWidgetColor SuccessfulAttackColor, EWidgetColor UnsuccessfulAttackColor)
	{
		local string UIMessage;

		UIMessage = GetDamageMessage();
		if (UIMessage == "")
			UIMessage = class'XGLocalizedData'.default.HealthDamaged;

		if( m_iShredded > 0 )
		{
			ShowShreddedMessage(SuccessfulAttackColor);
		}
		if( m_iMitigated > 0 )
		{
			ShowMitigationMessage(UnsuccessfulAttackColor);
		}
		if(m_iShielded > 0)
		{
			ShowShieldedMessage(UnsuccessfulAttackColor);
		}
		if(m_iDamage > 0)
		{
			ShowHPDamageMessage(UIMessage, , SuccessfulAttackColor);
		}

		// ADDED
		if (m_iDamage == 0)
		{
			Unit.UnitSpeak('TakingFire');
		}
		else // END OF ADDED
		if( m_iMitigated > 0 && ShouldPlayArmorHitVO())
		{
			Unit.UnitSpeak('ArmorHit');
		}
		else if(m_iShielded > 0 || m_iDamage > 0)
		{
			Unit.UnitSpeak('TakingDamage');
		}
	}

	simulated function ShowGrazeMessage(EWidgetColor SuccessfulAttackColor, EWidgetColor UnsuccessfulAttackColor)
	{
		if( m_iShredded > 0 )
		{
			ShowShreddedMessage(SuccessfulAttackColor);
		}
		if( m_iMitigated > 0 )
		{
			ShowMitigationMessage(UnsuccessfulAttackColor);
		}
		if(m_iShielded > 0)
		{
			ShowShieldedMessage(UnsuccessfulAttackColor);
		}
		if(m_iDamage > 0)
		{
			ShowHPDamageMessage(class'XGLocalizedData'.default.GrazeHit, , SuccessfulAttackColor);
		}

		// ADDED
		if (m_iDamage == 0)
		{
			Unit.UnitSpeak('TakingFire');
		}
		else // END OF ADDED
		if( m_iMitigated > 0 && ShouldPlayArmorHitVO())
		{
			Unit.UnitSpeak('ArmorHit');
		}
		else if(m_iShielded > 0 || m_iDamage > 0)
		{
			Unit.UnitSpeak('TakingDamage');
		}
	}

Begin:
	if (!bHiddenAction)
	{
		GroupState = UnitState.GetGroupMembership();
		if( GroupState != None )
		{
			for( ScanGroup = 0; ScanGroup < GroupState.m_arrMembers.Length; ++ScanGroup )
			{
				ScanUnit = XGUnit(`XCOMHISTORY.GetVisualizer(GroupState.m_arrMembers[ScanGroup].ObjectID));
				if( ScanUnit != None )
				{
					ScanUnit.VisualizedAlertLevel = eAL_Red;
					ScanUnit.IdleStateMachine.CheckForStanceUpdateOnIdle();
				}
			}
		}

		if( bShowFlyovers )
		{
			ShowAttackMessages();
		}

		if( bWasHit || m_iDamage > 0 || m_iMitigated > 0)       //  misses can deal damage
		{
			`PRES.m_kUnitFlagManager.RespondToNewGameState(Unit, StateChangeContext.GetLastStateInInterruptChain(), true);

			// The unit was hit but may be locked in a persistent CustomIdleOverrideAnim state
			// Check to see if we need to temporarily suspend that to play a reaction
			OverrideOldUnitState = XComGameState_Unit(Metadata.StateObject_OldState);
			bDoOverrideAnim = class'X2StatusEffects'.static.GetHighestEffectOnUnit(OverrideOldUnitState, OverridePersistentEffectTemplate, true);

			OverrideAnimEffectString = "";
			if( bDoOverrideAnim )
			{
				// Allow new animations to play
				UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
				OverrideAnimEffectString = string(OverridePersistentEffectTemplate.EffectName);
			}

			if (ShouldPlayAnimation())
			{
				// Particle effects should only play when the animation plays.  mdomowicz 2015_07_08
				// Update: if the attacker's animation uses AnimNotify_FireWeaponVolley, the hit effect will play 
				// via X2UnifiedProjectile, so in that case we should skip the hit effect here.  mdomowicz 2015_07_29
				if (!AttackersAnimUsesWeaponVolleyNotify())
				{
					if( SourceUnitState != None && SourceUnitState.IsUnitAffectedByEffectName(class'X2Effect_BloodTrail'.default.EffectName) && HitResult == eHit_Success )
					{
						EffectHitEffectsOverride = eHit_Crit;
					}
					else
					{
						EffectHitEffectsOverride = HitResult;
					}
					UnitPawn.PlayHitEffects(m_iDamage, DamageDealer, m_vHitLocation, DamageTypeName, m_vMomentum, bIsUnitRuptured, HitResult);
				}

				Unit.ResetWeaponsToDefaultSockets();
				AnimParams.AnimName = ComputeAnimationToPlay(OverrideAnimEffectString);

				if( AnimParams.AnimName != '' )
				{
					AnimParams.PlayRate = GetMoveAnimationSpeed();
					PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);
				}

				kPerkContent = XGUnit(DamageDealer) != none ? XGUnit(DamageDealer).GetPawn().GetPerkContent(string(AbilityTemplate.Name)) : none;
				if( kPerkContent != none && kPerkContent.m_PerkData.TargetActivationAnim.PlayAnimation && kPerkContent.m_PerkData.TargetActivationAnim.AdditiveAnim )
				{
					AnimParams.AnimName = class'XComPerkContent'.static.ChooseAnimationForCover(Unit, kPerkContent.m_PerkData.TargetActivationAnim);
					UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(AnimParams);
				}
				DoTargetAdditiveAnims();
			}
			else if( bMoving && RunningAction != None )
			{
				RunningAction.TriggerRunFlinch();
			}
			else
			{
				//`LOG("HurtAnim not playing", , 'XCom_Visualization');
			}

			if( !bGoingToDeathOrKnockback && !bSkipWaitForAnim && (PlayingSequence != none))
			{
				if( Metadata.VisualizeActor.CustomTimeDilation < 1.0 )
				{
					Sleep(PlayingSequence.AnimSeq.SequenceLength * PlayingSequence.Rate * Metadata.VisualizeActor.CustomTimeDilation);
				}
				else
				{
					FinishAnim(PlayingSequence);
				}
				bShouldContinueAnim = false;
			}

			if( bDoOverrideAnim )
			{
				// Turn off new animation playing
				UnitPawn.GetAnimTreeController().SetAllowNewAnimations(false);
			}
		}
		else
		{
			if (ShouldPlayAnimation())
			{
				if(bCounterAttackAnim)
				{
					AnimParams.AnimName = 'HL_Counterattack';					
				}
				else
				{
					Unit.ResetWeaponsToDefaultSockets();

					if( Unit.IsTurret() )  //@TODO - rmcfall/jbouscher - this selection may need to eventually be based on other factors, such as the current state of the unit
					{
						if( Unit.GetTeam() == eTeam_Alien )
						{
							AnimParams.AnimName = 'NO_Flinch_Advent';
						}
						else
						{
							AnimParams.AnimName = 'NO_Flinch_Xcom';
						}
					}
					else if( HitResult == eHit_Deflect || HitResult == eHit_Parry )
					{
						AnimParams.AnimName = 'HL_Deflect';
						if( AbilityTemplate != None && AbilityTemplate.IsMelee() )
						{
							AnimParams.AnimName = 'HL_DeflectMelee';
						}
						// Jwats: No matter what we were doing, we should now just idle (don't peek stop)
						Unit.IdleStateMachine.OverwriteReturnState('Idle');
					}
					else if( HitResult == eHit_Reflect )
					{
						AnimParams.AnimName = 'HL_ReflectStart';
					}
					else
					{
						switch( Unit.m_eCoverState )
						{
						case eCS_LowLeft:
						case eCS_HighLeft:
							AnimParams.AnimName = 'HL_Flinch';
							break;
						case eCS_LowRight:
						case eCS_HighRight:
							AnimParams.AnimName = 'HR_Flinch';
							break;
						case eCS_None:
							// Jwats: No cover randomizes between the 2 animations
							if( Rand(2) == 0 )
							{
								AnimParams.AnimName = 'HL_Flinch';
							}
							else
							{
								AnimParams.AnimName = 'HR_Flinch';
							}
							break;
						}
					}
				}				

				PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);
				DoTargetAdditiveAnims();
			}
			else if( bMoving && RunningAction != None )
			{
				RunningAction.TriggerRunFlinch();
			}
			else
			{
				//`LOG("DodgeAnim not playing");
			}

			if( !bGoingToDeathOrKnockback && (PlayingSequence != none))
			{
				if( Metadata.VisualizeActor.CustomTimeDilation < 1.0 )
				{
					Sleep(PlayingSequence.AnimSeq.SequenceLength * PlayingSequence.Rate * Metadata.VisualizeActor.CustomTimeDilation);
				}
				else
				{
					FinishAnim(PlayingSequence);
				}
				bShouldContinueAnim = false;
			}

			if (!bWasCounterAttack)
			{
				Unit.UnitSpeak('TakingFire');
			}
		}

		if( !bMoving )
		{
			if( PlayingSequence != None && !bGoingToDeathOrKnockback )
			{
				Sleep(0.0f);
				while( bShouldContinueAnim )
				{
					PlayingSequence.ReplayAnim();
					FinishAnim(PlayingSequence);
					bShouldContinueAnim = false;
					Sleep(0.0f); // Wait to see if another projectile comes
				}
			}
			else if( PlayingSequence != None && bGoingToDeathOrKnockback )
			{
				//Only play the hit react if there is more than one projectile volley
				if( !SingleProjectileVolley() )
				{
					Sleep(HitReactDelayTimeToDeath * GetDelayModifier()); // Let the hit react play for a little bit before we CompleteAction to go to death
				}
			}
		}
	}

	kPerkContent = XGUnit(DamageDealer) != none ? XGUnit(DamageDealer).GetPawn().GetPerkContent(string(AbilityTemplate.Name)) : none;
	if( kPerkContent != none && kPerkContent.m_PerkData.TargetActivationAnim.PlayAnimation && kPerkContent.m_PerkData.TargetActivationAnim.AdditiveAnim )
	{
		AnimParams.AnimName = class'XComPerkContent'.static.ChooseAnimationForCover(Unit, kPerkContent.m_PerkData.TargetActivationAnim);
		UnitPawn.GetAnimTreeController().RemoveAdditiveDynamicAnim(AnimParams);
	}
	UnDoTargetAdditiveAnims();

	CompleteAction();
}