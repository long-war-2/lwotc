class AnimNotify_ArmRocket extends AnimNotify_Scripted;

//	This notify is used during Arm Rocket animation.
//	It changes the Socket in a nearby neighboring PlaySocketAnimation notify,
//	so that will try to PlaySocketAnimation on the mesh of the currently armed rocket.

//	So far only Tactical Nuke takes advantage of this.

/*
struct native AnimNotifyEvent
{
    var()    float                   Time;
    var()    instanced AnimNotify    Notify;
    var()    editoronly Name         Comment;
    var()    float                   Duration;
};		
*/

var() editinline int AnimNotifyToAffect;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComAnimNotify_PlaySocketAnim	PlaySocketAnimNotify;
	local XComUnitPawn				Pawn;
	local XGUnitNativeBase			OwnerUnit;
	local XComWeapon				Rocket;
	local XComGameState_Item		WeaponState;
	local XComGameState				GameState;
	local XComGameState_Unit		UnitState;
	local UnitValue					UV;
	local XComGameState_Effect		NukeArmedEffectState;
	local int						iTurnsRemaining;

	////`LOG("Arm Rocket Notify Activated",, 'IRIROCK');

	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		Rocket = XComWeapon(Pawn.Weapon);
		OwnerUnit = Pawn.GetGameUnit();
		UnitState = OwnerUnit.GetVisualizedGameState();
		GameState = UnitState.GetParentGameState();

		//	Acquire Weapon State of the correct rocket on the soldier's body. We need it, because its nickname stores which socket is used by the rocket that's being Armed.
		WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(Rocket.m_kGameWeapon.ObjectID));
		if (WeaponState != none)
		{
			WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponState.SoldierKitOwner.ObjectID));
		}
		if (WeaponState == none)
		{
			`redscreen("Unable to access correct WeaponState for the Armed Rocket. -Iridar");
			return;
		}

		//	Acquire Effect State for the effect that tracks how many turns until the tactical nuke self detonates.
		NukeArmedEffectState = UnitState.GetUnitAffectedByEffectState('IRI_Nuke_Armed_Effect');
		if (NukeArmedEffectState != none)
		{
			iTurnsRemaining = NukeArmedEffectState.iTurnsRemaining;

			//	Treat the effect as if it has one extra turn remaining.
			iTurnsRemaining++;
		}
		else
		{
			`redscreen("Unable to access Effect State for the Armed Rocket. -Iridar");
			return;
		}

		////`LOG("Active Weapon ID: " @ Rocket.m_kGameWeapon.ObjectID @ " name: " @ WeaponState.GetMyTemplateName() @ "effect duration remaining:" @ NukeArmedEffectState.iTurnsRemaining,, 'IRIROCK');

		//	In case someone configures the Nuke to have longer detonation timer than 3 turns.
		if (iTurnsRemaining > 3) iTurnsRemaining = 3;

		////`LOG("Playing anim: " @ Name("ArmRocket_" $ iTurnsRemaining),, 'IRIROCK');

		if (UnitState.GetUnitValue(class'X2Effect_ArmRocket'.default.UnitValueName, UV))
		{
			////`LOG("Armed Rocket ID: " @ UV.fValue,, 'IRIROCK');
			
			if (Rocket.m_kGameWeapon.ObjectID == UV.fValue)
			{
				////`LOG("Match found, playing anim on socket: " @ WeaponState.Nickname,, 'IRIROCK');
				PlaySocketAnimNotify = XComAnimNotify_PlaySocketAnim(AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToAffect].Notify); 
				PlaySocketAnimNotify.SocketName = Name(WeaponState.Nickname);
				PlaySocketAnimNotify.AnimName = Name("ArmRocket_" $ iTurnsRemaining);
				//PlaySocketAnimNotify.AnimName = 'ArmRocket_3';
				//PlaySocketAnimNotify.Looping = true;
				//PlaySocketAnimNotify.Additive = true;
				//AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToAffect].Notify = PlaySocketAnimNotify;
			}
		}
	}
}