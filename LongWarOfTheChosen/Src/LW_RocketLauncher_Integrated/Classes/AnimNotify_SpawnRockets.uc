class AnimNotify_SpawnRockets extends AnimNotify_Scripted;

//	This is a very specific notify, activated during Take Rocket animation, which gets triggered during Give Rocket ability visualization.
//	This notify is paired to an Item Attach notify. When Spawn Rockets notify is played, it will replace the Item Attach notify with a new one. 
//	When Give Rocket is activated, it instantly gives the rocket item to the soldier, and - since it's a weapon - it gets Initialzied right away.
//	The Weapon Initialized catches that, and temporarily changes the rocket's default socket to 'RocketClip0'
//	The Item Attach notify created by Spawn Rockets moves the rocket from the 'RocketClip0' to whichever socket the rocket is actually supposed to use.
//	This whole complicated system is necessary to make sure the rocket appears on the soldier's body only after the specific moment in the Take Rocket animation.

/*
struct native AnimNotifyEvent
{
    var()    float                   Time;
    var()    instanced AnimNotify    Notify;
    var()    editoronly Name         Comment;	//	not accessible from code
    var()    float                   Duration;
};		
*/

var() editinline int AnimNotifyToInject;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComAnimNotify_ItemAttach	InjectNotify;
	local XComGameState_Unit		UnitState;
	local XGUnitNativeBase			OwnerUnit;
	local XComUnitPawn				Pawn;
	local XComWeapon				Rocket;
	local XGWeapon					RocketVis;
	//local SpawnMeshNotityEffect		PFX;
	local XComGameState_Item		WeaponState;
	local UnitValue					RocketValue;

	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		//Rocket = XComWeapon(Pawn.Weapon);	// this gets you the rocket on the soldier that initiated the Give Rocket interaction, which is useless here.
		OwnerUnit = Pawn.GetGameUnit();
		UnitState = OwnerUnit.GetVisualizedGameState();

		//	Give Rocket effect puts a Unit Value on the target soldier, which contains the Object ID of the paired cosmetic rocket that was just equipped on the soldier.
		if (UnitState != none && UnitState.GetUnitValue('IRI_Rocket_Value', RocketValue))
		{
			//	We use the Unit Value to get the Weapon State of that cosmetic rocket.
			//	The free socket / rocket slot that was assigned to that rocket is recorded in the rocket's Item State's nickname.
			WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(int(RocketValue.fValue)));

			if (WeaponState != none) 
			{
				////`LOG("Spawn Rockets -> Moving rocket to socket: " @ WeaponState.Nickname,, 'IRIDAR');

				InjectNotify = new class'XComAnimNotify_ItemAttach';
				InjectNotify.FromSocket = 'RocketClip0';
				InjectNotify.ToSocket = Name(WeaponState.Nickname);
				AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToInject].Notify = InjectNotify;

				//	Clear the Unit Value so that multiple rockets can be taken during one turn.
				//	Weapon Initialized also looks for the Unit Value, so clearing it ensures there's no double dipping into it.
				UnitState.ClearUnitValue('IRI_Rocket_Value');

				//	Set the new default socket for the taken rocket. This is necessary to ensure the soldier can properly take several rockets over the course of one mission.
				RocketVis = XGWeapon(WeaponState.GetVisualizer());
				if (RocketVis != none)
				{
					Rocket = RocketVis.GetEntity();
					if (Rocket != none)
					{
						Rocket.DefaultSocket = Name(WeaponState.Nickname);
					}
					else `redscreen("Spawn Rockets -> Could not get XComWeapon for the taken Rocket.-Iridar");
				}
				else `redscreen("Spawn Rockets -> Could not get XGWeapon for the taken Rocket.-Iridar");

				// activate persistent particle effects on rocket mesh, if there are any
				/*if (Rocket.m_arrParticleEffects.Length != 0)	
				{
					PFX.PSTemplate = Rocket.m_arrParticleEffects[0].PSTemplate;
					PFX.PSSocket = 'gun_fire';
					InjectNotify.SkeletalMeshFX.AddItem(PFX);
				}*/
			}
			else `redscreen("Spawn Rockets -> Could not get Weapon State for the taken Rocket.-Iridar");
		}
		else `redscreen("Spawn Rockets -> Could not get Unit Value for the taken Rocket.-Iridar");
    }
}

/*

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComAnimNotify_SpawnMesh	InjectNotify;
	//local XGUnitNativeBase			OwnerUnit;
	local XComUnitPawn				Pawn;
	local XComWeapon				Rocket;
	local XComGameState_Item		WeaponState;
	local SpawnMeshNotityEffect		PFX;
	//local int i;

	//`LOG("=================================",, 'IRIDAR');
	//`LOG("AnimNotify_SpawnRockets in: " @ AnimSeqInstigator.AnimSeqName,, 'IRIDAR');

	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		Rocket = XComWeapon(Pawn.Weapon);
		//OwnerUnit = Pawn.GetGameUnit();
		WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Rocket.m_kGameWeapon.ObjectID));

		InjectNotify = new class'XComAnimNotify_SpawnMesh';
		InjectNotify.SkeletalMesh = SkeletalMeshComponent(Rocket.Mesh).SkeletalMesh;
		InjectNotify.bSpawn = true;
		InjectNotify.AttachSocket = Name(WeaponState.Nickname);
		
		if (Rocket.m_arrParticleEffects.Length != 0)	// activate persistent particle effects on rocket mesh, if there are any
		{
			PFX.PSTemplate = Rocket.m_arrParticleEffects[0].PSTemplate;
			PFX.PSSocket = 'gun_fire';
			InjectNotify.SkeletalMeshFX.AddItem(PFX);
		}

		AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToInject].Notify = InjectNotify;	
    }
}*/

/*

const NumSockets = 4;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComAnimNotify_SpawnMesh	InjectNotify;
	local XGUnitNativeBase			OwnerUnit;
	local XComUnitPawn				Pawn;
	local X2Action					CurrentAction;
	local XComWeapon				Rocket;
	local XComGameState_Unit		UnitState;
	local XComGameStateHistory		History;

	//	Have to use separate UnitValues because GetUnitValue doesn't change UnitValue if it doesn't exist in the UnitState
	local UnitValue					RocketValue, EmptyRocketValue;
	local XComGameState_Item		WeaponState;
	local SpawnMeshNotityEffect		PFX;
	local int i;

	//`LOG("=================================",, 'IRIDAR');
	//`LOG("AnimNotify_SpawnRockets in: " @ AnimSeqInstigator.AnimSeqName,, 'IRIDAR');

	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		////`LOG("Pawn is not none.",, 'IRIDAR');
		Rocket = XComWeapon(Pawn.Weapon);
		History = `XCOMHISTORY;
		OwnerUnit = Pawn.GetGameUnit();
		//UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Pawn.ObjectID));	//	returns none for some reason
		//UnitState = XComGameState_Unit(History.GetGameStateForObjectID(WeaponState.OwnerStateObject.ObjectID));	

		WeaponState = XComGameState_Item(History.GetGameStateForObjectID(Rocket.m_kGameWeapon.ObjectID));
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OwnerUnit.ObjectID));	
		

		if (UnitState == none) //`LOG("Unit State si none.",, 'IRIDAR');

		if (Rocket != none && UnitState != none && WeaponState!= none)
		{
		
			//`LOG("Unit: " @ UnitState.GetFullName(),, 'IRIDAR');
			//`LOG("Weapon: " @ WeaponState.GetMyTemplate().DataName @ ", nickname: " @ WeaponState.Nickname,, 'IRIDAR');

			//	this check is necessary because apparently GiveRocket triggers all instances of DisplayRocket ability, including rockets the solder has already had equipped
			//if (Len(WeaponState.Nickname) > 3 && ) return;	//	if the rocket has already been processed we don't need to do anything
			
			InjectNotify = new class'XComAnimNotify_SpawnMesh';
			InjectNotify.SkeletalMesh = SkeletalMeshComponent(Rocket.Mesh).SkeletalMesh;
			InjectNotify.bSpawn = true;

			for (i=1; i < NumSockets + 1; i++)	
			{
				RocketValue = EmptyRocketValue;
				UnitState.GetUnitValue(Name("RocketClip" $ i), RocketValue);

				//`LOG("Step " @ i @ ": Unit Value: " @ RocketValue.fValue,, 'IRIDAR');

				if (RocketValue.fValue == 0) break;
			}
			if (i == NumSockets + 1)
			{
				WeaponState.Nickname = "nosocket";
				return;
			}
			
			WeaponState.Nickname = "RocketClip" $ i;
			InjectNotify.AttachSocket = Name("RocketClip" $ i);
			UnitState.SetUnitFloatValue(Name(WeaponState.Nickname), 1, eCleanup_BeginTactical);

			UpdateRocket(UnitState, History, WeaponState.GetMyTemplateName(), "RocketClip" $ i);

			//`LOG("Socket: " @ WeaponState.Nickname,, 'IRIDAR');

			if (Rocket.m_arrParticleEffects.Length != 0)	// activate persistent particle effects on rocket mesh, if there are any
			{
				PFX.PSTemplate = Rocket.m_arrParticleEffects[0].PSTemplate;
				PFX.PSSocket = 'gun_fire';
				InjectNotify.SkeletalMeshFX.AddItem(PFX);
			}

			AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToInject].Notify = InjectNotify;	
		}
    }
}

static function UpdateRocket(XComGameState_Unit UnitState, XComGameStateHistory History, name TemplateName, string NewNickname)
{
	local StateObjectReference	ObjRef;
	local XComGameState_Item	WeaponState;

	foreach UnitState.InventoryItems(ObjRef)
	{
		WeaponState = XComGameState_Item(History.GetGameStateForObjectID(ObjRef.ObjectID));

		if (WeaponState.GetMyTemplateName() == TemplateName)
		{
			//`LOG("Found weapon: " @ WeaponState.GetMyTemplate().DataName @ ", current nickname: " @ WeaponState.Nickname @ ", setting it to: " @ NewNickname,, 'IRIDAR');
			WeaponState.Nickname = NewNickname;
		}
	}
}*/

/*event OnInit(UIScreen Screen)
{
	local XComGameStateHistory				History;
	local XComGameState_Item				OldItemState, NewItemState;
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	OldXComHQState;	
	local XComGameState_HeadquartersXCom	NewXComHQState;
	local int i;

	if (UICustomize(Screen) != none)
	{
		if(class'X2DownloadableContentInfo_ImprovedSoldierGeneration'.default.CHANGE_COLOR_FOR_WEAPONS_IN_HQ_INVENTORY)
		{
			//`LOG("UIScreenListener_IRI_ISG running.",, 'IRIDAR');

			History = `XCOMHISTORY;

			//	Create a new game state which will contain recolored items
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Iridar Recoloring Weapons");

			//	Grab the current HQ Game State
			OldXComHQState = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

			//	Copy it into a new HQ Game State
			NewXComHQState = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', OldXComHQState.ObjectID));

			for (i=0; i<OldXComHQState.Inventory.Length; i++)	//	go through all items in HQ Inventory
			{
				OldItemState = XComGameState_Item(History.GetGameStateForObjectID(OldXComHQState.Inventory[i].ObjectID));	//	Grab the item's Item State
					
				if (X2WeaponTemplate(OldItemState.GetMyTemplate()) != none)	//	if the Item is a weapon
				{
					//	if the mod is configured to recolor only weapons with "NO_COLOR", and the weapon already has a color set, we move on to the next item in the inventory
					if(class'X2DownloadableContentInfo_ImprovedSoldierGeneration'.default.RECOLOR_ONLY_WEAPONS_WITH_NO_TINT && OldItemState.WeaponAppearance.iWeaponTint != INDEX_NONE) continue;

					//	we copy the weapon's item state
					NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', OldXComHQState.Inventory[i].ObjectID));

					//	change its color
					NewItemState.WeaponAppearance.iWeaponTint = class'X2DownloadableContentInfo_ImprovedSoldierGeneration'.default.DEFAULT_WEAPON_TINT;

					//	and replace the old weapon Item State in the HQ Inventory with a recolored one
					NewXComHQState.Inventory[i] = NewItemState.OwnerStateObject;
				}
			}
			//	After we cycle through the inventory, we add the HQ state with recolored items into new game state
			NewGameState.AddStateObject(NewXComHQState);
			//	and submit it
			History.AddGameStateToHistory(NewGameState);
		}
	}
}
*/



			/*
			WeaponState.Nickname = "RocketClip1";
			UnitState.GetUnitValue(Name(WeaponState.Nickname), RocketValue1);	
			//`LOG("Step 1: Unit Value: " @ RocketValue1.fValue,, 'IRIDAR');
			if (RocketValue1.fValue == 0)
			{
				InjectNotify.AttachSocket = 'RocketClip1';
			}
			else
			{	
				WeaponState.Nickname = "RocketClip2";
				UnitState.GetUnitValue(Name(WeaponState.Nickname), RocketValue2);	
				//`LOG("Step 2: Unit Value: " @ RocketValue2.fValue,, 'IRIDAR');
				if (RocketValue2.fValue == 0)
				{
					InjectNotify.AttachSocket = 'RocketClip2';
				}
				else
				{
					WeaponState.Nickname = "RocketClip3";
					UnitState.GetUnitValue(Name(WeaponState.Nickname), RocketValue3);	
					//`LOG("Step 3: Unit Value: " @ RocketValue3.fValue,, 'IRIDAR');
					if (RocketValue3.fValue == 0)
					{
						InjectNotify.AttachSocket = 'RocketClip3';
					}
					else
					{
						WeaponState.Nickname = "RocketClip4";
						UnitState.GetUnitValue(Name(WeaponState.Nickname), RocketValue4);	
						//`LOG("Step 4: Unit Value: " @ RocketValue4.fValue,, 'IRIDAR');
						if (RocketValue4.fValue == 0)
						{
							InjectNotify.AttachSocket = 'RocketClip4';
						}
						else
						{
							//`LOG("Step 5: nosocket",, 'IRIDAR');
							WeaponState.Nickname = "nosocket";
							return;
						}
					}
				}
			}*/