class AnimNotify_HandleRocket extends AnimNotify_Scripted;

//	This notify is used during Fire Rocket, Give Rocket and Take Rocket animations
//	it is used to create a rocket mesh in the soldier's hand, or to move the existing rocket mesh from the socket on the soldier's body to the hand.
//	It will check whether the rocket that is being fired/given still has ammo remaining
//	if this is the last rocket, this AnimNotify will inject a new Item Attach notify that will transfer the last rocket into soldier's hand
//	otherwise this notify will inject a new Spawn Mesh notify that will create a copy of the rocket in the soldier's hand

/*
struct native AnimNotifyEvent
{
    var()    float                   Time;
    var()    instanced AnimNotify    Notify;
    var()    editoronly Name         Comment;
    var()    float                   Duration;
};		
*/

var() editinline int AnimNotifyToInject;
var() editinline name AttachSocket;	//rocket_socket, but same as R_Hand basically
var() editinline bool ForTakingRocket;	// enabled only during Take Rocket animation

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComAnimNotify_SpawnMesh	SpawnMeshNotify;
	local XComAnimNotify_ItemAttach	ItemAttachNotify;
	local XGUnitNativeBase			OwnerUnit;
	local XComUnitPawn				Pawn;
	local XComWeapon				Rocket;
	//local XComWeapon				OldWeapon;
	local XComGameState_Item		WeaponState;
	local XComGameState				GameState;
	local XComGameState_Unit		UnitState;
	local int						Ammo;
	local UnitValue					UV;

	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		Rocket = XComWeapon(Pawn.Weapon);
		OwnerUnit = Pawn.GetGameUnit();
		UnitState = OwnerUnit.GetVisualizedGameState();
		GameState = UnitState.GetParentGameState();

		if (ForTakingRocket)
		{	
			//	The Unit Value contains the Object ID of the cosmetic rocket that was equipped on the soldier by X2 Effect Give Rocket.
			if (UnitState.GetUnitValue('IRI_Rocket_Value', UV))
			{
				WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(int(UV.fValue)));	

				//	If we're taking rocket, the rocket will not be the soldier's currently active weapon (Pawn.Weapon), so we get the rocket's game archetype the other way.
				Rocket = XComWeapon(`CONTENT.RequestGameArchetype(X2WeaponTemplate(WeaponState.GetMyTemplate()).GameArchetype));
			}
		}
		else
		{	
			WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(Rocket.m_kGameWeapon.ObjectID));
			Ammo = WeaponState.Ammo;	//	finding these problems is what happens when you use same variable name for different things...
			////`LOG("WeaponState.SoldierKitOwner.ObjectID" @ WeaponState.SoldierKitOwner.ObjectID,, 'IRIROCK');
			WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponState.SoldierKitOwner.ObjectID));
		}

		if (WeaponState != none) 
		{
			// if (ForTakingRocket) //`LOG("Handle rocket: " @ WeaponState.GetMyTemplateName() @ ", nickname: " @ WeaponState.Nickname,, 'IRIROCK');

			//	if this was the last rocket OR the rocket had no socket set up OR the soldier is receiving the rocket from another soldier
			if(Ammo > 0 || WeaponState.Nickname == "nosocket" || ForTakingRocket)
			{
				//	just spawn a new rocket mesh in their hand, no questions asked
				SpawnMeshNotify = new class'XComAnimNotify_SpawnMesh';
				SpawnMeshNotify.AttachSocket = AttachSocket; 
				SpawnMeshNotify.SkeletalMesh = SkeletalMeshComponent(Rocket.Mesh).SkeletalMesh;
				SpawnMeshNotify.bSpawn = true;
				AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToInject].Notify = SpawnMeshNotify;	
			}
			else
			{
				//	otheriwse, MOVE the rocket from its socket on soldier's body to soldier's hand.
				ItemAttachNotify = new class'XComAnimNotify_ItemAttach';
				ItemAttachNotify.FromSocket = name(WeaponState.Nickname);
				ItemAttachNotify.ToSocket = AttachSocket; 
				AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToInject].Notify = ItemAttachNotify;	

				`LOG("Handle rocket: " @ WeaponState.GetMyTemplateName() @ ", nickname: " @ WeaponState.Nickname,, 'IRIROCK');

				if (!ForTakingRocket)
				{
					//	and then nuke the cosmetic rocket item from the inventory
					if (UnitState.RemoveItemFromInventory(WeaponState, GameState))
					{
						GameState.RemoveStateObject(WeaponState.ObjectID);
						WeaponState = UnitState.GetItemInSlot(WeaponState.InventorySlot);
					}
					else `redscreen("AnimNotify_HandleRocket -> could not remove cosmetic rocket from the soldier: " @ UnitState.GetFullName() @ ".-Iridar");
				}
			}
		}
		else `redscreen("AnimNotify_HandleRocket -> could not retrieve Weapon State for cosmetic rocket on soldier " @ UnitState.GetFullName() @ " -Iridar");
    }
}