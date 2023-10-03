//*******************************************************************************************
//  FILE:   Psionic. stuff by TeslaRage and RustyDios                                
//  
//	File created	30/11/21	06:15
//	LAST UPDATED    29/01/22	09:30
//
//	FIXES UP THE ANYONE CAN EQUIP ANY PCS, STOLEN FROM PEXM, ADJUSTED FOR LW MOD
//
//*******************************************************************************************
class X2EventListener_PCSfix_LW extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateStrategyListener());	

	return Templates;
}

static final function CHEventListenerTemplate CreateStrategyListener()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'X2EventListener_PCSFix_LW');

	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OverrideCanEquipImplant', OnOverrideCanEquipImplant, ELD_Immediate, 50);

	return Template; 
}

/*
// FOR REF CALLED FROM UIInventory_Implants, note ne GameState so ensure is ELD_Immediate

	OverrideTuple = new class'XComLWTuple';
	OverrideTuple.Id = 'OverrideCanEquipImplant';
	OverrideTuple.Data.Add(2);
	OverrideTuple.Data[0].kind = XComLWTVBool;
	OverrideTuple.Data[0].b = CanEquipImplant;  
	OverrideTuple.Data[1].kind = XComLWTVObject;
	OverrideTuple.Data[1].o = Implant;	

	`XEVENTMGR.TriggerEvent('OverrideCanEquipImplant', OverrideTuple, Unit);
*/

static function EventListenerReturn OnOverrideCanEquipImplant(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
    local XComLWTuple Tuple;
 
    Tuple = XComLWTuple(EventData);
  
    if (Tuple != none)
    {
      Tuple.Data[0].b = true;
    }

    return ELR_NoInterrupt;
}