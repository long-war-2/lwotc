class X2AbilityCharges_RescueProtocol extends X2AbilityCharges;

var int CV_Charges; 
var int MG_Charges;
var int BM_Charges;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local XComGameState_Item ItemState;
    local X2GremlinTemplate GremlinTemplate;
    local int Charges;

    Charges = InitialCharges;
    ItemState = Ability.GetSourceWeapon();
    if(ItemState != none)
    {
        GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
        if(GremlinTemplate != none)
        {
			switch (GremlinTemplate.DataName)
			{
				case 'Gremlin_CV': Charges = CV_Charges; break;
				case 'Gremlin_MG': Charges = MG_Charges; break;
				case 'Gremlin_BM': Charges = BM_Charges; break;
				Default: break;
			}
        }
    }
    return Charges;
}

defaultproperties
{
    InitialCharges=1
}