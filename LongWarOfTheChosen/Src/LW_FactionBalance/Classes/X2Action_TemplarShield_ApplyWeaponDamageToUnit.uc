class X2Action_TemplarShield_ApplyWeaponDamageToUnit extends X2Action_ApplyWeaponDamageToUnit;

// A version of Damage Unit action does not play any animations and plays a different voiceover if the attack didn't cause HP damage.

simulated function bool ShouldPlayAnimation()
{
	return false;
}

// Same as original, just using different speech when not taking health damage.
simulated state Executing
{
	simulated event BeginState(name nmPrevState)
	{
		super.BeginState(nmPrevState);
		
		//Rumbles controller
		Unit.CheckForLowHealthEffects();
	}

	//Returns the string we should use to call out damage - potentially using "Burning", "Poison", etc. instead of the default
	simulated function string GetDamageMessage()
	{
		if (X2Effect_Persistent(DamageEffect) != none)
			return X2Effect_Persistent(DamageEffect).FriendlyName;

		if (X2Effect_Persistent(OriginatingEffect) != None)
			return X2Effect_Persistent(OriginatingEffect).FriendlyName;

		if (X2Effect_Persistent(AncestorEffect) != None)
			return X2Effect_Persistent(AncestorEffect).FriendlyName;

		return "";
	}

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

	simulated function ShowCritMessage(EWidgetColor SuccessfulAttackColor, EWidgetColor UnsuccessfulAttackColor)
	{
		Unit.UnitSpeak('CriticallyWounded');
		
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
			ShowHPDamageMessage(GetDamageMessage(), class'XGLocalizedData'.default.CriticalHit, SuccessfulAttackColor);
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

	simulated function ShowHPDamageMessage(string UIMessage, optional string CritMessage, optional EWidgetColor DisplayColor = eColor_Bad)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), UIMessage, UnitPawn.m_eTeamVisibilityFlags, , m_iDamage, 0, CritMessage, DamageTypeName == 'Psi'? eWDT_Psi : -1, DisplayColor);
	}

	simulated function ShowMitigationMessage(EWidgetColor DisplayColor)
	{
		local int CurrentArmor;
		CurrentArmor = UnitState.GetArmorMitigationForUnitFlag();
		//The flyover shows the armor amount that exists after shred has been applied.
		if (CurrentArmor > 0)
		{
			class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XGLocalizedData'.default.ArmorMitigation, UnitPawn.m_eTeamVisibilityFlags, , CurrentArmor, /*modifier*/, /*crit*/, eWDT_Armor, DisplayColor);
		}
	}

	simulated function ShowShieldedMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XGLocalizedData'.default.ShieldedMessage, UnitPawn.m_eTeamVisibilityFlags, , m_iShielded,,,, DisplayColor);
	}

	simulated function ShowShreddedMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XGLocalizedData'.default.ShreddedMessage, UnitPawn.m_eTeamVisibilityFlags, , m_iShredded, , , eWDT_Shred, DisplayColor);
	}

	simulated function ShowImmuneMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XLocalizedData'.default.UnitIsImmuneMsg, UnitPawn.m_eTeamVisibilityFlags, , , , , , DisplayColor);
	}

	simulated function ShowMissMessage(EWidgetColor DisplayColor)
	{
		local String MissedMessage;

		MissedMessage = OriginatingEffect.OverrideMissMessage;
		if( MissedMessage == "" )
		{
			MissedMessage = class'XLocalizedData'.default.MissedMessage;
		}

		if (m_iDamage > 0)
			class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), MissedMessage, UnitPawn.m_eTeamVisibilityFlags, , m_iDamage,,,, DisplayColor);
		else if (!OriginatingEffect.IsA('X2Effect_Persistent')) //Persistent effects that are failing to cause damage are not noteworthy.
			class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), MissedMessage,,,,,,, DisplayColor);
	}

	simulated function ShowCounterattackMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XLocalizedData'.default.CounterattackMessage,,,,,,, DisplayColor);
	}

	simulated function ShowLightningReflexesMessage(EWidgetColor DisplayColor)
	{
		local XComGameState_HeadquartersXCom XComHQ;
		local XComGameStateHistory History;
		local string DisplayMessageString;

		History = `XCOMHISTORY;
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		if( XComHQ.TacticalGameplayTags.Find('DarkEvent_LightningReflexes') != INDEX_NONE )
		{
			DisplayMessageString = class'XLocalizedData'.default.DarkEvent_LightningReflexesMessage;
		}
		else
		{
			DisplayMessageString = class'XLocalizedData'.default.LightningReflexesMessage;
		}

		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), DisplayMessageString, , , , , , , DisplayColor);
	}

	simulated function ShowUntouchableMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XLocalizedData'.default.UntouchableMessage,,,,,,, DisplayColor);
	}

	simulated function ShowParryMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XLocalizedData'.default.ParryMessage,,,,,,, DisplayColor);
	}

	simulated function ShowDeflectMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XLocalizedData'.default.DeflectMessage,,,,,,, DisplayColor);
	}

	simulated function ShowReflectMessage(EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'XLocalizedData'.default.ReflectMessage,,,,,,, DisplayColor);
	}

	simulated function ShowFreeKillMessage(name AbilityName, EWidgetColor DisplayColor)
	{
		local X2AbilityTemplate Template;
		local string KillMessage;

		KillMessage = class'XLocalizedData'.default.FreeKillMessage;

		if (AbilityName != '')
		{
			Template = class'XComGameState_Ability'.static.GetMyTemplateManager( ).FindAbilityTemplate( AbilityName );
			if ((Template != none) && (Template.LocFlyOverText != ""))
			{
				KillMessage = Template.LocFlyOverText;
			}
		}

		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), KillMessage, , , , , , eWDT_Repeater, DisplayColor);
	}

	simulated function ShowSpecialDamageMessage(DamageModifierInfo SpecialMessage, EWidgetColor DisplayColor)
	{
		class'UIWorldMessageMgr'.static.DamageDisplay(m_vHitLocation, Unit.GetVisualizedStateReference(), class'Helpers'.static.GetMessageFromDamageModifierInfo(SpecialMessage),,,,,, (SpecialMessage.Value > 0) ? eWDT_Shred : eWDT_Armor, DisplayColor);
	}

	
	simulated function ShowAttackMessages()
	{			
		local int i, SpecialDamageIndex;
		local ETeam TargetUnitTeam;
		local EWidgetColor SuccessfulAttackColor, UnsuccessfulAttackColor;

		if(!class'X2TacticalVisibilityHelpers'.static.IsUnitVisibleToLocalPlayer(UnitState.ObjectId, CurrentHistoryIndex))
			return;

		TargetUnitTeam = UnitState.GetTeam();
		if( TargetUnitTeam == eTeam_XCom || TargetUnitTeam == eTeam_Resistance )
		{
			SuccessfulAttackColor = eColor_Bad;
			UnsuccessfulAttackColor = eColor_Good;
		}
		else
		{
			SuccessfulAttackColor = eColor_Good;
			UnsuccessfulAttackColor = eColor_Bad;
		}

		if (HitResults.Length == 0 && DamageResults.Length == 0 && bWasHit)
		{
			// Must be damage from World Effects (Fire, Poison, Acid)
			ShowDamageMessage(SuccessfulAttackColor, UnsuccessfulAttackColor);
		}
		else
		{
			//It seems that misses contain a hit result but no damage results. So fill in some zero / null damage result entries if there is a mismatch.
			if(HitResults.Length > DamageResults.Length)
			{				
				for( i = 0; i < HitResults.Length; ++i )
				{
					if( class'XComGameStateContext_Ability'.static.IsHitResultMiss(HitResults[i]))
					{
						DamageResults.Insert(i, 1);
					}
				}
			}

			if( bCombineFlyovers )
			{
				m_iDamage = 0;
				m_iMitigated = 0;
				m_iShielded = 0;
				m_iShredded = 0;
				for( i = 0; i < HitResults.Length && i < DamageResults.Length; i++ ) // some abilities damage the same target multiple times
				{
					if( HitResults[i] == eHit_Success )
					{
						m_iDamage += DamageResults[i].DamageAmount;
						m_iMitigated += DamageResults[i].MitigationAmount;
						m_iShielded += DamageResults[i].ShieldHP;
						m_iShredded += DamageResults[i].Shred;
					}
				}

				ShowDamageMessage(SuccessfulAttackColor, UnsuccessfulAttackColor);
			}
			else
			{
				for( i = 0; i < HitResults.Length && i < DamageResults.Length; i++ ) // some abilities damage the same target multiple times
				{
					HitResult = HitResults[i];

					m_iDamage = DamageResults[i].DamageAmount;
					m_iMitigated = DamageResults[i].MitigationAmount;
					m_iShielded = DamageResults[i].ShieldHP;
					m_iShredded = DamageResults[i].Shred;

					if( DamageResults[i].bFreeKill )
					{
						ShowFreeKillMessage( DamageResults[i].FreeKillAbilityName, SuccessfulAttackColor);
						return;
					}

					for( SpecialDamageIndex = 0; SpecialDamageIndex < DamageResults[i].SpecialDamageFactors.Length; ++SpecialDamageIndex )
					{
						ShowSpecialDamageMessage(DamageResults[i].SpecialDamageFactors[SpecialDamageIndex], (DamageResults[i].SpecialDamageFactors[SpecialDamageIndex].Value > 0) ? SuccessfulAttackColor : UnsuccessfulAttackColor);
					}

					if (DamageResults[i].bImmuneToAllDamage)
					{
						ShowImmuneMessage(UnsuccessfulAttackColor);
						continue;
					}

					switch( HitResult )
					{
					case eHit_CounterAttack:
						ShowCounterattackMessage(UnsuccessfulAttackColor);
						break;
					case eHit_LightningReflexes:
						ShowLightningReflexesMessage(UnsuccessfulAttackColor);
						break;
					case eHit_Untouchable:
						ShowUntouchableMessage(UnsuccessfulAttackColor);
						break;
					case eHit_Crit:
						ShowCritMessage(SuccessfulAttackColor, UnsuccessfulAttackColor);
						break;
					case eHit_Graze:
						ShowGrazeMessage(SuccessfulAttackColor, UnsuccessfulAttackColor);
						break;
					case eHit_Success:
						ShowDamageMessage(SuccessfulAttackColor, UnsuccessfulAttackColor);
						break;
					case eHit_Parry:
						ShowParryMessage(UnsuccessfulAttackColor);
						break;
					case eHit_Deflect:
						ShowDeflectMessage(UnsuccessfulAttackColor);
						break;
					case eHit_Reflect:
						ShowReflectMessage(UnsuccessfulAttackColor);
						break;
					default:
						ShowMissMessage(UnsuccessfulAttackColor);
						break;
					}
				}
			}
		}
	}

	function bool SingleProjectileVolley()
	{
		local XGUnit DealerUnit;

		DealerUnit = XGUnit(DamageDealer);

		if (DealerUnit == none) // if melee is treated as a single volley, treat collateral damage as a single as well.
			return true;

		// Jwats: Melee doesn't have a volley so treat no volley as a single volley
		return DealerUnit.GetPawn().GetAnimTreeController().GetNumProjectileVolleys() <= 1;
	}

	function bool AttackersAnimUsesWeaponVolleyNotify()
	{
		local array<AnimNotify_FireWeaponVolley> OutNotifies;
		local array<float> OutNotifyTimes;
		local XGUnit DealerUnit;

		DealerUnit = XGUnit(DamageDealer);

		if (DealerUnit == none)
			return false;

		DealerUnit.GetPawn().GetAnimTreeController().GetFireWeaponVolleyNotifies(OutNotifies, OutNotifyTimes);
		return (OutNotifies.length > 0);
	}

	function DoTargetAdditiveAnims()
	{
		local name TargetAdditiveAnim;
		local CustomAnimParams CustomAnim;

		CustomAnim.Additive = true;
		foreach TargetAdditiveAnims(TargetAdditiveAnim)
		{
			CustomAnim.AnimName = TargetAdditiveAnim;
			UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(CustomAnim);
		}
	}

	function UnDoTargetAdditiveAnims()
	{
		local name TargetAdditiveAnim;
		local CustomAnimParams CustomAnim;

		CustomAnim.Additive = true;
		CustomAnim.TargetWeight = 0.0f;
		foreach TargetAdditiveAnims(TargetAdditiveAnim)
		{
			CustomAnim.AnimName = TargetAdditiveAnim;
			UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(CustomAnim);
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