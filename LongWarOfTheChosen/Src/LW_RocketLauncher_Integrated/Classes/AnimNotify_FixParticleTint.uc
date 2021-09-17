class AnimNotify_FixParticleTint extends AnimNotify_Scripted dependson(ParticleSystem);

var() editinline int AnimNotifyToTint;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComUnitPawn			Pawn;
	//local XComWeapon			Weapon;
	//local XComGameState_Item	InternalWeaponState;
	local AnimNotify_PlayParticleEffect	Notify;
	local ParticleSystem		PSTemplate;
	local int i;

    Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {
		//Weapon = XComWeapon(Pawn.Weapon);
		//InternalWeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Weapon.m_kGameWeapon.ObjectID));

		Notify = AnimNotify_PlayParticleEffect(AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToTint].Notify);
		
		if (Notify != none)
		{
			PSTemplate = Notify.PSTemplate;
			if (PSTemplate != none)
			{
				////`LOG("Begin print out",, 'IRIROCKET');


				for (i = 0; i < PSTemplate.Emitters.Length; i++)
				{
					////`LOG("Found: " @ PSTemplate.Emitters[i].EmitterName,, 'IRIROCKET');
				}
				

				/*
				for (i = 0; i < PSTemplate.ParticleSystemDefaults.InstanceParameters.Length; i++)
				{
					//`LOG("Found: " @ PSTemplate.ParticleSystemDefaults.InstanceParameters[i].Name,, 'IRIROCKET');
				}*/
			}
			//else //`LOG("No PSTemplate",, 'IRIROCKET');
		}
		//else //`LOG("No PS Notify",, 'IRIROCKET');
    }
	//else //`LOG("No pawn",, 'IRIROCKET');
}

/*
[0064.43] IRIROCKET: Begin print out
[0064.43] IRIROCKET: Found:  DropAT4
[0064.43] IRIROCKET: Found:  Smoke_Shells
[0064.43] IRIROCKET: Found:  Smoke
[0064.43] IRIROCKET: Found:  sparks
[0064.43] IRIROCKET: Found:  Circle_Distort
[0064.43] IRIROCKET: Found:  Orthogonal
[0064.43] IRIROCKET: Found:  Main
[0064.43] IRIROCKET: Found:  Glow
[0064.43] IRIROCKET: Found:  Light
*/