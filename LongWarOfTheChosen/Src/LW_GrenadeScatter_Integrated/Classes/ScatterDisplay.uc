class ScatterDisplay extends Actor config (Scatter) dependson (X2DownloadableContentInfo_LW_GrenadeScatter_Integrated);

var localized string ScatterText1;
var localized string ScatterText2;

var UIScrollingTextField			ScatterAmountText;
var UITacticalHUD_AbilityContainer	AbilityContainer;

// How many decimals to show for the scatter value
const places = 2;

var protected transient XComEmitter ExplosionEmitter;
var protected transient XComEmitter ExplosionEmitter_Miss;

var config bool bDrawGrenadeScatterInsteadOfBlastRadius;

event PostBeginPlay()
{
	local UITacticalHUD TacticalHud;

	//TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
	//	Theoretically a few cpu cycles faster (c) Xymanek
	TacticalHUD = `Pres.GetTacticalHUD();
	AbilityContainer = TacticalHUD.m_kAbilityHUD;

	//	Initialize UI Text var.
	if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterText)
	{
		ScatterAmountText = TacticalHUD.Spawn(class'UIScrollingTextField', TacticalHUD);
		ScatterAmountText.bAnimateOnInit = false;
		ScatterAmountText.InitScrollingText('MissScatterText_IRI', "", 400, 0, 0);
		ScatterAmountText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("N/A", eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));
		ScatterAmountText.ShowShadow(0);
	
		//	Scatter Text is initially hidden.
		ScatterAmountText.Hide();
	}

	//	Set up scatter display
	if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterCircles)
	{
		ExplosionEmitter = `BATTLE.spawn(class'XComEmitter');
		ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("IRI_GrenadeScatter.BlastRadius_Min", class'ParticleSystem')));
		ExplosionEmitter.LifeSpan = 604800; // never die (or at least take a week to do so)
		ExplosionEmitter.SetRotation( rot(0,0,1) );

		ExplosionEmitter_Miss = `BATTLE.spawn(class'XComEmitter');
		ExplosionEmitter_Miss.SetTemplate(ParticleSystem(DynamicLoadObject("IRI_GrenadeScatter.BlastRadius_Max", class'ParticleSystem')));
		ExplosionEmitter_Miss.LifeSpan = 604800; // never die (or at least take a week to do so)
		ExplosionEmitter_Miss.SetRotation( rot(0,0,1) );
	}
}

event Tick(float DeltaTime)
{
	local vector2d					vCursorPos;
	local float						EffectiveAim;
	local ScatterStruct				ScatterParams;
	local XComGameState_Ability		Ability;
	local vector					AimLocation;
	local XComGameState_Unit		UnitState;
	local XComTacticalController	TacticalController;
	local XGUnit					ActiveUnit;
	local X2TargetingMethod			TargetingMethod;
	local string					OutputString;
	//local float						HalfAbilityRadius;

	TacticalController = XComTacticalController(GetALocalPlayerController());
	
	//	If the player is currently doing any targeting
	if (TacticalController != none && AbilityContainer != none && AbilityContainer.IsTargetingMethodActivated())
	{		
		//	Acquire Unit State of the soldier that's doing the targeting.
		ActiveUnit = TacticalController.GetActiveUnit();
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ActiveUnit.ObjectID));

		//	Acquire ability state that's doing the targeting.
		TargetingMethod = AbilityContainer.GetTargetingMethod();
		Ability = TargetingMethod.Ability;

		//	Acquire Aim Location
		if (X2TargetingMethod_Grenade(TargetingMethod) != none)
		{
			AimLocation = X2TargetingMethod_Grenade(TargetingMethod).GetSplashRadiusCenter(!X2TargetingMethod_Grenade(TargetingMethod).SnapToTile);
		}
		else
		{
			//	AimLocation = TacticalController.GetCursorPosition();
			//	This should be controller-friendly.
			AimLocation = `Cursor.GetCursorFeetLocation();
		}

		AimLocation.Z += class'XComWorldData'.const.WORLD_HalfFloorHeight; // Raise indicators a little so they don't fall under ground.

		if (Ability != none)
		{
			//	This function will return false if the ability that's doing the targeting has no scatter configuration.
			//	I.e. this ability does not have scatter at all.
			if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.static.GetScatterParamsForEffectiveAim(Ability, UnitState, AimLocation, ScatterParams, EffectiveAim))
			{
				//	Display scatter text
				if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterText)
				{
					vCursorPos = LocalPlayer(`LOCALPLAYERCONTROLLER.Player).Project(AimLocation);
					ScatterAmountText.SetPosition((vCursorPos.X+1)*960 - 15, (1-vCursorPos.Y)*540 + 50);

					//	Build a colored string compiled of EffectiveAim / HitScatter / MissScatter. Displayed in game as: 55% / 1.0 / 4.0
					OutputString = class'UIUtilities_Text'.static.GetColoredText(int(EffectiveAim) $ "% / ", eUIState_Normal, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);

					if (EffectiveAim < 0)	//	Scatter will always miss, so display only miss scatter
					{
						OutputString = OutputString $ class'UIUtilities_Text'.static.GetColoredText(GetHTMLScatterValueText(ScatterParams.MissScatter), eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
					}
					else if (EffectiveAim > 100)	//	Scatter will always hit, so display only hit chance
					{
						OutputString = OutputString $ class'UIUtilities_Text'.static.GetColoredText(GetHTMLScatterValueText(ScatterParams.HitScatter), eUIState_Good, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
					}
					else	//	Can hit or miss, show both values
					{
						OutputString = OutputString $ class'UIUtilities_Text'.static.GetColoredText(GetHTMLScatterValueText(ScatterParams.HitScatter), eUIState_Good, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
						OutputString = OutputString $ class'UIUtilities_Text'.static.GetColoredText(" / ", eUIState_Normal, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
						OutputString = OutputString $ class'UIUtilities_Text'.static.GetColoredText(GetHTMLScatterValueText(ScatterParams.MissScatter), eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
					}
					//	Set the text
					ScatterAmountText.SetHTMLText(OutputString);

					//	Make it visible and exit the function.
					ScatterAmountText.Show();
				}

				//	Draw scatter radius
				if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterCircles)
				{
					if(AimLocation != ExplosionEmitter.Location)
					{
						ExplosionEmitter.SetLocation(AimLocation); // Set initial location of emitter

						if (bDrawGrenadeScatterInsteadOfBlastRadius)
						{
							ExplosionEmitter.SetDrawScale(ScatterParams.HitScatter * 2);
						}
						else
						{
							ExplosionEmitter.SetDrawScale(Round(ScatterParams.HitScatter) * 2 + Ability.GetAbilityRadius() / class'XComWorldData'.const.WORLD_HalfStepSize);
						}
						
						if( !ExplosionEmitter.ParticleSystemComponent.bIsActive )
						{
							ExplosionEmitter.ParticleSystemComponent.ActivateSystem();			
						}
					}

					if (AimLocation != ExplosionEmitter_Miss.Location)
					{
						ExplosionEmitter_Miss.SetLocation(AimLocation); // Set initial location of emitter

						if (bDrawGrenadeScatterInsteadOfBlastRadius)
						{	
							ExplosionEmitter_Miss.SetDrawScale(ScatterParams.MissScatter * 2);
						}
						else
						{
							ExplosionEmitter_Miss.SetDrawScale(Round(ScatterParams.MissScatter) * 2 + Ability.GetAbilityRadius() / class'XComWorldData'.const.WORLD_HalfStepSize);
						}

						if( !ExplosionEmitter_Miss.ParticleSystemComponent.bIsActive )
						{
							ExplosionEmitter_Miss.ParticleSystemComponent.ActivateSystem();			
						}
					}
				}
				return;
			}
		}
	}
	//	In all other situations, hide the scatter text.
	if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterText)
	{
		ScatterAmountText.Hide();
	}

	//	And the scatter display.
	if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterCircles)
	{
		ExplosionEmitter.ParticleSystemComponent.DeactivateSystem();
		ExplosionEmitter_Miss.ParticleSystemComponent.DeactivateSystem();
	}
}


event Destroyed ()
{
	//	Need to check, could've been already removed due to screen's (HUD's) removal (c) Xymanek
	if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterText)
	{
		if (ScatterAmountText != none)
		{
			ScatterAmountText.Remove();
		}
	}
	if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.bDisplayScatterCircles)
	{
		if (ExplosionEmitter != none)
		{
		ExplosionEmitter.Destroy();
		}
		if (ExplosionEmitter_Miss != none)
		{
			ExplosionEmitter_Miss.Destroy();
		}
	}
}

//	Helper functions
static function string GetHTMLScatterValueText(float value)
{
	local string FloatString, TempString;
	local int i;
	local float TempFloat, TestFloat;

	TempFloat = value;
	for (i=0; i< places; i++)
	{
		TempFloat *= 10.0;
	}
	TempFloat = Round(TempFloat);
	for (i=0; i< places; i++)
	{
		TempFloat /= 10.0;
	}

	TempString = string(TempFloat);
	for (i = InStr(TempString, ".") + 1; i < Len(TempString) ; i++)
	{
		FloatString = Left(TempString, i);
		TestFloat = float(FloatString);
		if (TempFloat ~= TestFloat)
		{
			break;
		}
	}

	if (Right(FloatString, 1) == ".")
	{
		FloatString $= "0";
	}

	return FloatString;
}
