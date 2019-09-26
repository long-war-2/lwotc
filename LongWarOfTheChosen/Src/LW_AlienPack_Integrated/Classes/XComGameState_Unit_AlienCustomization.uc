//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Unit_AlienCustomization.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This component stores the appearance and related info for a single customizated alien unit
//---------------------------------------------------------------------------------------
class XComGameState_Unit_AlienCustomization extends XComGameState_BaseObject 
		dependson(XComGameState_AlienCustomizationManager) config(LW_AlienPack);

//`include(LW_AlienPack_Integrated\LW_AlienPack.uci)

var bool bAutomatic;
var float fScale;

var transient XComUnitPawn Pawn;

//abilities and stat changes will be persistently stored in the owning XComGameState_Unit, so don't have to be stored explicitly here
// changes to pawns are not persistent, and so have to be stored and re-applied on load
var LWObjectAppearance BodyAppearance;	
var LWObjectAppearance PrimaryWeaponAppearance;
var LWObjectAppearance SecondaryWeaponAppearance;
var TAppearance m_kAppearance;
var array<string> GenericBodyPartArchetypes;

var array<PawnContentRequest>   PawnContentRequests;
// Dynamic content
var XComHeadContent HeadContent;
var XComArmsContent ArmsContent;
var XComLegsContent LegsContent;
var XComTorsoContent TorsoContent;
var XComHelmetContent  HelmetContent;
//var array<XComPatternsContent> PatternsContent;

//Left / Right arm customization. Transient to avoid conflicts with base game cooked packages
var transient privatewrite XComArmsContent LeftArmContent;
var transient privatewrite XComArmsContent RightArmContent;
var transient privatewrite XComArmsContent LeftArmDecoContent;
var transient privatewrite XComArmsContent RightArmDecoContent;

Delegate OnBodyPartLoadedDelegate(PawnContentRequest ContentRequest);

simulated function XComGameState_Unit GetUnit()
{
	if (OwningObjectId > 0)
	{
		return XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
	}
	return none;
}

simulated function InitComponent()
{

}

static function XComGameState_Unit_AlienCustomization GetCustomizationComponent(XComGameState_Unit Unit)
{
	if (Unit != none) 
		return XComGameState_Unit_AlienCustomization(Unit.FindComponentObject(class'XComGameState_Unit_AlienCustomization'));
	return none;
}

static function XComGameState_Unit_AlienCustomization CreateCustomizationComponent(XComGameState_Unit Unit, XComGameState NewGameState)
{
	local XComGameState_Unit_AlienCustomization AlienCustomization;

	AlienCustomization = XComGameState_Unit_AlienCustomization(NewGameState.CreateStateObject(class'XComGameState_Unit_AlienCustomization'));
	Unit.AddComponentObject(AlienCustomization);
	AlienCustomization.InitComponent();
	return AlienCustomization;
}

simulated function GenerateCustomization(LWUnitVariation UnitVariation, XComGameState_Unit UnitState, XComGameState NewGameState)
{

	//save off body part and material customization so it can be re-applied after save/load cycle
	m_kAppearance = UnitVariation.BodyPartContent;
	fScale = UnitVariation.Scale;
	bAutomatic = UnitVariation.Automatic;
	BodyAppearance = UnitVariation.BodyAppearance;
	GenericBodyPartArchetypes = UnitVariation.GenericBodyPartArchetypes;
	PrimaryWeaponAppearance = UnitVariation.PrimaryWeaponAppearance;
	SecondaryWeaponAppearance = UnitVariation.SecondaryWeaponAppearance;
}

simulated function bool ApplyCustomization(optional XComUnitPawn PawnToUpdate, optional bool bUpdateItems = true)
{
	local bool bSuccess;
	local XComGameState_Unit Unit;
	//local XComUnitPawn Pawn;

	bSuccess = true;
	Unit = GetUnit();

	if(PawnToUpdate == none) // check for an existing pawn (e.g. cinematic)
	{
		if(!GetUnitPawn(Pawn)) // no pawn, so try and retrieve the fully loaded pawn
			return false;
	}
	else
	{
		Pawn = PawnToUpdate;
	}

	//body parts
	RequestFullPawnContent();
	AddGenericBodyPartContent();

	//scale
	if(fScale > 0.25)
		if(!ApplyScale())
			bSuccess = false;

	//body appearance
	if(!ApplyBodyMaterialCustomization())
	{
		bSuccess = false;
		`APTRACE("AlienCustomization: Failed to apply Body Material Customization.");
	}
	//primary weapon appearance
	if(!ApplyItemMaterialCustomization(Unit.GetPrimaryWeapon(), PrimaryWeaponAppearance))
		bSuccess = false;

	//secondary weapon appearance
	if(!ApplyItemMaterialCustomization(Unit.GetSecondaryWeapon(), SecondaryWeaponAppearance))
		bSuccess = false;

	return bSuccess;
}

//handles updating cinematic pawn creation
function EventListenerReturn OnCinematicPawnCreation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local UIPawnMgr PawnMgr;
	local XComUnitPawn CinematicPawn;
	local int PawnInfoIndex;
	local XComGameState_Item PrimaryWeapon, SecondaryWeapon;
	local XComWeapon PrimaryWeaponPawn, SecondaryWeaponPawn;
	local array<PawnInfo> PawnStore;

	UnitState = XComGameState_Unit(EventSource);
	CinematicPawn = XComUnitPawn(EventData);

	if(UnitState == none || CinematicPawn == none)
		return ELR_NoInterrupt;
		
	if(UnitState.ObjectID != OwningObjectId)
	{
		`REDSCREEN("AlienCustomization : OnCinematicPawnCreation called with mismatching Unit");
		return ELR_NoInterrupt;
	}

	ApplyCustomization(CinematicPawn, false); // update the supplied cinematic pawn instead of the default visualizer, and don't update default items

	PawnMgr = `HQPRES.GetUIPawnMgr();
	if(PawnMgr == none)
		return ELR_NoInterrupt;

	PawnInfoIndex = PawnMgr.Pawns.Find('PawnRef', UnitState.ObjectID);
	if (PawnInfoIndex != -1)
		PawnStore = PawnMgr.Pawns;
	else
		PawnInfoIndex = PawnMgr.CinematicPawns.Find('PawnRef', UnitState.ObjectID);

	if (PawnInfoIndex == -1)
	{
		`REDSCREEN("AlienCustomization : OnCinematicPawnCreation called with no Cinematic pawn found in UIPawnMgr");
		return ELR_NoInterrupt;
	}
	else
	{
		PawnStore = PawnMgr.CinematicPawns;
	}

	PrimaryWeapon = UnitState.GetPrimaryWeapon();
	if(PrimaryWeapon != none)
	{
		PrimaryWeaponPawn = XComWeapon(PawnStore[PawnInfoIndex].Weapons[eInvSlot_PrimaryWeapon]);
		if(PrimaryWeaponPawn != none)
			ApplyItemMaterialCustomization(PrimaryWeapon, PrimaryWeaponAppearance, PrimaryWeaponPawn);
	}
	SecondaryWeapon = UnitState.GetSecondaryWeapon();
	if(SecondaryWeapon != none)
	{
		SecondaryWeaponPawn = XComWeapon(PawnStore[PawnInfoIndex].Weapons[eInvSlot_SecondaryWeapon]);
		if(SecondaryWeaponPawn != none)
			ApplyItemMaterialCustomization(SecondaryWeapon, SecondaryWeaponAppearance, SecondaryWeaponPawn);
	}

	
	return ELR_NoInterrupt;
}

// -------------------------------------------------------------
// --------- UTILITY FUNCTIONS FOR UPDATING PAWN ---------------
// -------------------------------------------------------------

//from XComGameState_Unit
//function bool IsGroupLeader(optional XComGameState NewGameState=None)


function bool GetUnitPawn(out XComUnitPawn OutPawn)
{
	local XGUnit Visualizer;

	Visualizer = XGUnit(GetUnit().GetVisualizer());
	if(Visualizer == none)
		return false;
	OutPawn = Visualizer.GetPawn();
	if(OutPawn == none)
		return false;

	return true;
}

function bool ApplyScale()
{
	//local XComUnitPawn Pawn;

	//if(!GetUnitPawn(Pawn))
		//return false;

	Pawn.Mesh.SetScale(fScale);
	return true;
}

//applies an armor tint to an alien
// since we don't have TAppearance (it's only defined for XComHumanPawn), we have to directly hack in and change MIC values
function bool ApplyBodyMaterialCustomization()
{
	//local XComUnitPawn Pawn;
	local MeshComponent AttachedComponent;
	local int i;

	//if(!GetUnitPawn(Pawn))
		//return false;

	UpdateMaterials(Pawn.Mesh, BodyAppearance);
	for (i = 0; i < Pawn.Mesh.Attachments.Length; ++i)
	{
		AttachedComponent = MeshComponent(Pawn.Mesh.Attachments[i].Component);
		if (AttachedComponent != none)
		{
			UpdateMaterials(AttachedComponent, BodyAppearance);
		}
	}
	return true;
}

function bool ApplyItemMaterialCustomization(XComGameState_Item ItemState, LWObjectAppearance Appearance, optional XComWeapon WeaponPawn)
{
	local XGWeapon Visualizer;
	//local XComWeapon WeaponPawn;
	local MeshComponent MeshComp, AttachedComponent;
	local int i;

	if(WeaponPawn == none)
	{
		if (ItemState == none)
			return false;
		Visualizer = XGWeapon(ItemState.GetVisualizer());
		if(Visualizer == none)
			return false;
		WeaponPawn = XComWeapon(Visualizer.m_kEntity);
		if(WeaponPawn == none)
			return false;
	}

	MeshComp = WeaponPawn.Mesh;
	UpdateMaterials(MeshComp, Appearance);
	
	for(i = 0; i < SkeletalMeshComponent(MeshComp).Attachments.Length; ++i)
	{
		AttachedComponent = MeshComponent(SkeletalMeshComponent(MeshComp).Attachments[i].Component);
		if(AttachedComponent != none)
		{
			UpdateMaterials(AttachedComponent, Appearance);
		}
	}
	return true;
}

simulated function UpdateMaterials(MeshComponent MeshComp, LWObjectAppearance Appearance)
{
	local int i;
	local MaterialInterface Mat;
	local MaterialInstanceConstant MIC, NewMIC;

	if (MeshComp != none)
	{
		for (i = 0; i < MeshComp.GetNumElements(); ++i)
		{
			Mat = MeshComp.GetMaterial(i);
			MIC = MaterialInstanceConstant(Mat);

			// It is possible for there to be MITVs in these slots, so check
			if (MIC != none)
			{
				// If this is not a child MIC, make it one. This is done so that the material updates below don't stomp
				// on each other between units.
				if (InStr(MIC.Name, "MaterialInstanceConstant") == INDEX_NONE)
				{
					NewMIC = new (self) class'MaterialInstanceConstant';
					NewMIC.SetParent(MIC);
					MeshComp.SetMaterial(i, NewMIC);
					MIC = NewMIC;
				}

				UpdateIndividualMaterial(MeshComp, MIC, Appearance);
			}
		}
	}
}

// Logic largely based off of UpdateArmorMaterial in XComHumanPawn
simulated function UpdateIndividualMaterial(MeshComponent MeshComp, MaterialInstanceConstant MIC, LWObjectAppearance Appearance)
{
	local MaterialInterface ParentMat;
	local MaterialInstanceConstant ParentMIC;
	local name ParentName;
	local LWColorParameter ColorParameter;
	local LWScalarParameter ScalarParameter;

	// It is possible for there to be MITVs in these slots, so check
	if (MIC != none)
	{
				
		ParentMat = MIC.Parent;
		while (!ParentMat.IsA('Material'))
		{
			ParentMIC = MaterialInstanceConstant(ParentMat);
			if (ParentMIC != none)
				ParentMat = ParentMIC.Parent;
			else
				break;
		}
		ParentName = ParentMat.Name;

		switch (ParentName)
		{
			case 'Props_SD_FX_Chunks':
			case 'AlienUnit_TC':
			case 'WeaponCustomizable_TC':
			case 'M_Master_PwrdWep_TC':
				foreach Appearance.ColorParameters(ColorParameter)
				{
					`APTRACE("Alien Customization: Setting Vector Parameter.");
					MIC.SetVectorParameterValue(ColorParameter.ParameterName, ColorParameter.ColorValue);
				}
				foreach Appearance.ScalarParameters(ScalarParameter)
				{
					MIC.SetScalarParameterValue(ScalarParameter.ParameterName, ScalarParameter.ScalarValue);
				}
				break;
			case 'Alien_SD_Cloth':						
				break;
			case 'Alien_SD_SSS':
				foreach Appearance.ColorParameters(ColorParameter)
				{
					MIC.SetVectorParameterValue(ColorParameter.ParameterName, ColorParameter.ColorValue);
				}
				break;
			default:
				`APTRACE("UpdateMeshMaterials: Unknown material" @ ParentName @ "found on" @ self @ MeshComp);
				break;
		}
	}
}


//body part loading -- mostly copied from XComHumanPawn
simulated function RequestFullPawnContent()
{
	local PawnContentRequest kRequest;

	PawnContentRequests.Length = 0;

	//Order matters here, because certain pieces of content can affect other pieces of content. IE. a selected helmet can affect which mesh the hair uses, or disable upper or lower face props
	if(m_kAppearance.nmTorso != '')
	{
		kRequest.ContentCategory = 'Torso';
		kRequest.TemplateName = m_kAppearance.nmTorso;
		kRequest.BodyPartLoadedFn = OnTorsoLoaded;
		PawnContentRequests.AddItem(kRequest);
	}

	//head content is just for eyebrows, head morphs -- not needed for ADVENT/aliens
	//if (m_kAppearance.nmHead != '')
	//{
		//kRequest.ContentCategory = 'Head';
		//kRequest.TemplateName = m_kAppearance.nmHead;
		//kRequest.BodyPartLoadedFn = OnHeadLoaded;
		//PawnContentRequests.AddItem(kRequest);
	//}

	if(m_kAppearance.nmHelmet != '') 
	{
		kRequest.ContentCategory = 'Helmets';
		kRequest.TemplateName = m_kAppearance.nmHelmet;
		kRequest.BodyPartLoadedFn = OnHelmetLoaded;
		PawnContentRequests.AddItem(kRequest);
	}

	if(m_kAppearance.nmArms != '')		  
	{
		kRequest.ContentCategory = 'Arms';
		kRequest.TemplateName = m_kAppearance.nmArms;
		kRequest.BodyPartLoadedFn = OnArmsLoaded;
		PawnContentRequests.AddItem(kRequest);
	}

	if(m_kAppearance.nmLeftArm != '')
	{
		kRequest.ContentCategory = 'LeftArm';
		kRequest.TemplateName = m_kAppearance.nmLeftArm;
		kRequest.BodyPartLoadedFn = OnArmsLoaded;
		PawnContentRequests.AddItem(kRequest);
	}

	if(m_kAppearance.nmRightArm != '')		   
	{
		kRequest.ContentCategory = 'RightArm';
		kRequest.TemplateName = m_kAppearance.nmRightArm;
		kRequest.BodyPartLoadedFn = OnArmsLoaded;
		PawnContentRequests.AddItem(kRequest);
	}

	if(m_kAppearance.nmLegs != '')		   
	{
		kRequest.ContentCategory = 'Legs';
		kRequest.TemplateName = m_kAppearance.nmLegs;
		kRequest.BodyPartLoadedFn = OnLegsLoaded;
		PawnContentRequests.AddItem(kRequest);
	}

	//if (m_kAppearance.nmPatterns != '')
	//{
		//kRequest.ContentCategory = 'Patterns';
		//kRequest.TemplateName = m_kAppearance.nmPatterns;
		//kRequest.BodyPartLoadedFn = OnPatternsLoaded;
		//PawnContentRequests.AddItem(kRequest);
	//}

	//if(m_kAppearance.nmWeaponPattern != '')
	//{
		//kRequest.ContentCategory = 'Patterns';
		//kRequest.TemplateName = m_kAppearance.nmWeaponPattern;
		//kRequest.BodyPartLoadedFn = OnPatternsLoaded;
		//PawnContentRequests.AddItem(kRequest);
	//}

	//  Make the requests later. If they come back synchronously, their callbacks will also happen synchronously, and it can throw things out of whack
	MakeAllContentRequests();
}

simulated function MakeAllContentRequests()
{	
	local X2BodyPartTemplate PartTemplate;
	local X2BodyPartTemplateManager PartManager;
	local Delegate<OnBodyPartLoadedDelegate> BodyPartLoadedFn;
	local int i;
	
	PartManager = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();

	for(i = 0; i < PawnContentRequests.Length; ++i)
	{		
		PartTemplate = PartManager.FindUberTemplate(string(PawnContentRequests[i].ContentCategory), PawnContentRequests[i].TemplateName);
		if (PartTemplate != none) //If the part couldn't be found, then just ignore it. This could happen when loading a save that had DLC installed that we don't have
		{
			PawnContentRequests[i].ArchetypeName = name(PartTemplate.ArchetypeName);
			PawnContentRequests[i].Template = PartTemplate;
			if(PawnContentRequests[i].ArchetypeName != '')
			{
				`APTRACE("AlienVariations: Loading content " $ PartTemplate.ArchetypeName);
				PawnContentRequests[i].kContent = `CONTENT.RequestGameArchetype(PartTemplate.ArchetypeName, self, none, false);
				if(PawnContentRequests[i].kContent == none)
				{
					`redscreen("Couldn't load body part content:"@PartTemplate.ArchetypeName@"! The entry for this archetype needs to be fixed in DefaultContent.ini. @csulzbach");
				}

				BodyPartLoadedFn = PawnContentRequests[i].BodyPartLoadedFn;
				if(BodyPartLoadedFn != none)
				{
					BodyPartLoadedFn(PawnContentRequests[i]);
				}				
			}
			else
			{
				`redscreen("An empty archetype was specified for body part template"@PawnContentRequests[i].TemplateName@"! This is an invalid setting - remove the entry from DefaultContent.ini @csulzbach");
			}
		}
	}
}

simulated function OnTorsoLoaded(PawnContentRequest ContentRequest)
{
	TorsoContent = XComTorsoContent(ContentRequest.kContent);
	Pawn.m_kTorsoComponent.SetSkeletalMesh(TorsoContent.SkeletalMesh);
	Pawn.ResetMaterials(Pawn.m_kTorsoComponent);
	UpdateMaterials(Pawn.m_kTorsoComponent, BodyAppearance);
	Pawn.m_kTorsoComponent.SetParentAnimComponent(Pawn.Mesh);
	
	Pawn.Mesh.AppendSockets(Pawn.m_kTorsoComponent.Sockets, true);
	Pawn.MarkAuxParametersAsDirty(Pawn.m_bAuxParamNeedsPrimary, Pawn.m_bAuxParamNeedsSecondary, Pawn.m_bAuxParamUse3POutline);
}

simulated function OnHelmetLoaded(PawnContentRequest ContentRequest)
{
	HelmetContent = XComHelmetContent(ContentRequest.kContent);
	Pawn.m_kHelmetMC.SetSkeletalMesh(HelmetContent.SkeletalMesh);
	Pawn.ResetMaterials(Pawn.m_kHelmetMC);
	UpdateMaterials(Pawn.m_kHelmetMC, BodyAppearance);
	Pawn.m_kHelmetMC.SetParentAnimComponent(Pawn.Mesh);
	
	Pawn.Mesh.AppendSockets(Pawn.m_kHelmetMC.Sockets, true);
	Pawn.MarkAuxParametersAsDirty(Pawn.m_bAuxParamNeedsPrimary, Pawn.m_bAuxParamNeedsSecondary, Pawn.m_bAuxParamUse3POutline);
}

simulated function OnLegsLoaded(PawnContentRequest ContentRequest)
{
	LegsContent = XComLegsContent(ContentRequest.kContent);
	Pawn.m_kLegsMC.SetSkeletalMesh(LegsContent.SkeletalMesh);
	Pawn.ResetMaterials(Pawn.m_kLegsMC);
	UpdateMaterials(Pawn.m_kLegsMC, BodyAppearance);
	if(LegsContent.OverrideMaterial != none)
	{
		Pawn.m_kLegsMC.SetMaterial(0, LegsContent.OverrideMaterial);
	}
	Pawn.m_kLegsMC.SetParentAnimComponent(Pawn.Mesh);
	
	Pawn.Mesh.AppendSockets(Pawn.m_kLegsMC.Sockets, true);
	Pawn.MarkAuxParametersAsDirty(Pawn.m_bAuxParamNeedsPrimary, Pawn.m_bAuxParamNeedsSecondary, Pawn.m_bAuxParamUse3POutline);
}

simulated function OnArmsLoaded(PawnContentRequest ContentRequest)
{
	local SkeletalMeshComponent UseMeshComponent;
	local SkeletalMesh UseSkeletalMesh;
	local XComArmsContent UseArmsContent;	
	
	UseArmsContent = XComArmsContent(ContentRequest.kContent);		
	UseSkeletalMesh = UseArmsContent.SkeletalMesh;

	switch(ContentRequest.ContentCategory)
	{
		case 'Arms':		
			if(Pawn.m_kLeftArm != none && Pawn.m_kLeftArm.SkeletalMesh != none)
				Pawn.m_kLeftArm.SetSkeletalMesh(none);

			if(Pawn.m_kRightArm != none && Pawn.m_kRightArm.SkeletalMesh != none)
				Pawn.m_kRightArm.SetSkeletalMesh(none);

			if(Pawn.m_kLeftArmDeco != none && Pawn.m_kLeftArmDeco.SkeletalMesh != none)
				Pawn.m_kLeftArmDeco.SetSkeletalMesh(none);

			if(Pawn.m_kRightArmDeco != none && Pawn.m_kRightArmDeco.SkeletalMesh != none)
				Pawn.m_kRightArmDeco.SetSkeletalMesh(none);

			UseMeshComponent = Pawn.m_kArmsMC;

			if(UseSkeletalMesh == none)
				Pawn.m_kArmsMC.SetSkeletalMesh(none);

			ArmsContent = UseArmsContent;
			break;
		case 'LeftArm':
			//Make sure the paired arms are gone
			if(Pawn.m_kArmsMC != none && Pawn.m_kArmsMC.SkeletalMesh != none)
				Pawn.m_kArmsMC.SetSkeletalMesh(none);

			UseMeshComponent = Pawn.m_kLeftArm;

			if(UseSkeletalMesh == none)
				Pawn.m_kLeftArm.SetSkeletalMesh(none);

			LeftArmContent = UseArmsContent;
			break;

		case 'RightArm':
			//Make sure the paired arms are gone
			if(Pawn.m_kArmsMC != none && Pawn.m_kArmsMC.SkeletalMesh != none)
				Pawn.m_kArmsMC.SetSkeletalMesh(none);

			UseMeshComponent = Pawn.m_kRightArm;

			if(UseSkeletalMesh == none)
				Pawn.m_kRightArm.SetSkeletalMesh(none);

			RightArmContent = UseArmsContent;
			break;

		case 'LeftArmDeco':
			UseMeshComponent = Pawn.m_kLeftArmDeco;

			if(UseSkeletalMesh == none)
				Pawn.m_kLeftArmDeco.SetSkeletalMesh(none);

			LeftArmDecoContent = UseArmsContent;
			break;

		case 'RightArmDeco':		
			UseMeshComponent = Pawn.m_kRightArmDeco;

			if(UseSkeletalMesh == none)
				Pawn.m_kRightArmDeco.SetSkeletalMesh(none);

			RightArmDecoContent = UseArmsContent;
			break;
	}

	//Make a new one and set it up
	if(Pawn.m_kArmsMC != UseMeshComponent)
	{
		Pawn.DetachComponent(UseMeshComponent);
		UseMeshComponent = new(Pawn) class'SkeletalMeshComponent';
	}
	
	switch(ContentRequest.ContentCategory)
	{
		case 'Arms':
			Pawn.m_kArmsMC = UseMeshComponent;
			break;
		case 'LeftArm':
			Pawn.m_kLeftArm = UseMeshComponent;
			break;
		case 'RightArm':
			Pawn.m_kRightArm = UseMeshComponent;
			break;
		case 'LeftArmDeco':
			Pawn.m_kLeftArmDeco = UseMeshComponent;
			break;
		case 'RightArmDeco':
			Pawn.m_kRightArmDeco = UseMeshComponent;
			break;
	}

	UseMeshComponent.LastRenderTime = Pawn.WorldInfo.TimeSeconds;	
	UseMeshComponent.SetSkeletalMesh(UseSkeletalMesh);
	Pawn.ResetMaterials(UseMeshComponent);
	UpdateMaterials(UseMeshComponent, BodyAppearance);
	if(UseArmsContent.OverrideMaterial != none)
	{
		UseMeshComponent.SetMaterial(0, UseArmsContent.OverrideMaterial);
	}

	if(UseMeshComponent.SkeletalMesh != none)
	{
		UseMeshComponent.SetParentAnimComponent(Pawn.Mesh);		
		Pawn.Mesh.AppendSockets(UseMeshComponent.Sockets, true);
	}

	//UpdateMeshMaterials(UseMeshComponent);

	if(Pawn.m_kArmsMC != UseMeshComponent)
	{
		Pawn.AttachComponent(UseMeshComponent); //Attach the new component
	}

	Pawn.MarkAuxParametersAsDirty(Pawn.m_bAuxParamNeedsPrimary, Pawn.m_bAuxParamNeedsSecondary, Pawn.m_bAuxParamUse3POutline);
}

function AddGenericBodyPartContent()
{
	local int GenericAttachmentIndex;
	local XComBodyPartContent BodyPartContent;
	local XComPawnPhysicsProp PhysicsProp;
	local SkeletalMeshComponent SkelMeshComp;
	local XComContentManager ContentMgr;	

	ContentMgr = `CONTENT;
		
	for(GenericAttachmentIndex = 0; GenericAttachmentIndex < GenericBodyPartArchetypes.Length; ++GenericAttachmentIndex)
	{
		BodyPartContent = XComBodyPartContent(ContentMgr.RequestGameArchetype(GenericBodyPartArchetypes[GenericAttachmentIndex], self, none, false));
		if(BodyPartContent == none)
			continue;
		//BodyPartContent = DefaultAttachments[GenericAttachmentIndex];
		if(BodyPartContent.SocketName != '' && Pawn.Mesh.GetSocketByName(BodyPartContent.SocketName) != none)
		{
			if(BodyPartContent.SkeletalMesh != none)
			{
				if(BodyPartContent.UsePhysicsAsset != none)
				{
					PhysicsProp = Pawn.Spawn(class'XComPawnPhysicsProp', Pawn);
					PhysicsProp.CollisionComponent = PhysicsProp.SkeletalMeshComponent;
					PhysicsProp.SetBase(Pawn);					
					PhysicsProp.SkeletalMeshComponent.SetSkeletalMesh(BodyPartContent.SkeletalMesh);

					Pawn.Mesh.AttachComponentToSocket(PhysicsProp.SkeletalMeshComponent, BodyPartContent.SocketName, BodyPartContent.SocketName);

					//Do NOT set bForceUpdateAttachmentsInTick because we need the cape to update in its selected tick group when attached to a ragdoll					
					if(BodyPartContent.UsePhysicsAsset != none)
					{						
						PhysicsProp.SkeletalMeshComponent.SetPhysicsAsset(BodyPartContent.UsePhysicsAsset, true);
						PhysicsProp.SkeletalMeshComponent.SetHasPhysicsAssetInstance(true);
						PhysicsProp.SkeletalMeshComponent.WakeRigidBody();
						PhysicsProp.SkeletalMeshComponent.PhysicsWeight = 1.0f;		
						PhysicsProp.SetTickGroup(TG_PostUpdateWork);						
					}					

					PhysicsProp.SkeletalMeshComponent.SetAcceptsDynamicDecals(FALSE); // Fix for blood puddles appearing on the hair.
					PhysicsProp.SkeletalMeshComponent.SetAcceptsStaticDecals(FALSE);

					Pawn.m_aPhysicsProps.AddItem(PhysicsProp);
				}
				else
				{
					SkelMeshComp = new(Pawn) class'SkeletalMeshComponent';
					SkelMeshComp.SetSkeletalMesh(BodyPartContent.SkeletalMesh);
					Pawn.Mesh.AttachComponentToSocket(SkelMeshComp, BodyPartContent.SocketName);
				}
			}
		}
		else if(BodyPartContent.SkeletalMesh != none)
		{
			SkelMeshComp = new(Pawn) class'SkeletalMeshComponent';						
			SkelMeshComp.SetSkeletalMesh(BodyPartContent.SkeletalMesh);
			SkelMeshComp.SetParentAnimComponent(Pawn.Mesh);			
			Pawn.Mesh.AppendSockets(SkelMeshComp.Sockets, true);
			Pawn.AttachComponent(SkelMeshComp);
			Pawn.AttachedMeshes.AddItem(SkelMeshComp);			
		}
	}	
}

defaultproperties
{
	bTacticalTransient=true
}
