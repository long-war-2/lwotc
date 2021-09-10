class AnimNotify_RemoveUnitFromPlay extends AnimNotify_Scripted;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComGameState_Unit		UnitState;
	local XGUnitNativeBase			OwnerUnit;
	local XComUnitPawn				Pawn;


	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		OwnerUnit = Pawn.GetGameUnit();
		UnitState = OwnerUnit.GetVisualizedGameState();

		//	Give Rocket effect puts a Unit Value on the target soldier, which contains the Object ID of the paired cosmetic rocket that was just equipped on the soldier.
		if (UnitState != none)
		{
			UnitState.RemoveUnitFromPlay();
		}
    }
}