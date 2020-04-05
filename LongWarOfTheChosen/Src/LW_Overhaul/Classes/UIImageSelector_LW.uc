//---------------------------------------------------------------------------------------
//  FILE:    UIImageSelector_LW.uc
//  AUTHOR:  robojumper
//  PURPOSE: (Copied from Better Squad Icon Selector mod). This is the grid used
//           for displaying squad icons in the squad icon selector screen.
//---------------------------------------------------------------------------------------

// this is mostly the same as UIColorSelector
class UIImageSelector_LW extends UIPanel;

var float ItemPadding;
var float EdgePadding;
var float ChipHeight;
var float ScrollbarPadding;

var UIScrollbar Scrollbar;
var UIMask Mask;
var UIPanel ChipContainer;

var array<UISquadImage> ImageChips;
var array<string> Images;

var int InitialSelection;

delegate OnPreviewDelegate(int iImageIndex);
delegate OnSetDelegate(int iImageIndex);

simulated function UIImageSelector_LW InitImageSelector(optional name InitName,
													optional float initX = 500,
													optional float initY = 500,
													optional float initWidth = 500,
													optional float initHeight = 500,
													optional array<string> initImages,
													optional delegate<OnPreviewDelegate> initPreviewDelegate,
													optional delegate<OnSetDelegate> initSetDelegate,
													optional int initSelection = 0)
{
	InitPanel(InitName);

	width = initWidth;
	height = initHeight;
	SetPosition(initX, initY);

	ChipContainer = Spawn(class'UIPanel', self).InitPanel();
	ChipContainer.bCascadeFocus = false;
	ChipContainer.bAnimateOnInit = false;
	ChipContainer.SetY(5); // offset slightly so the highlight for the chips shows up in the masked area
	ChipContainer.SetSelectedNavigation();

	OnPreviewDelegate = initPreviewDelegate;
	OnSetDelegate = initSetDelegate;

	InitialSelection = initSelection;

	CreateImageChips(initImages);

	ChipContainer.Navigator.OnSelectedIndexChanged = OnSelectionIndexChanged;
	return self;
}

simulated function CreateImageChips(array<string> _Images)
{
	local UISquadImage Chip, LeftNavTargetChip, RightNavTargetChip, UpNavTargetChip, DownNavTargetChip;
	local int iChip, iRow, iCol, iMaxChipsPerRow, iLastRowLength, iOffset;

	Images = _Images;

	iMaxChipsPerRow = int((width - ItemPadding) / (class'UISquadImage'.default.iDefaultSize + ItemPadding));

	iRow = 0;
	iCol = -1;

	// Create chips ----------------------------------------------------
	for (iChip = 0; iChip < Images.Length; iChip++)
	{
		iCol++;
		if (iCol >= iMaxChipsPerRow)
		{
			iCol = 0;
			iRow++;
		}

		Chip = Spawn(class'UISquadImage', ChipContainer);
		Chip.InitSquadImage('',
							iChip,
							Images[iChip],
							GetChipX(iCol),
							GetChipY(iRow),
							class'UISquadImage'.default.iDefaultSize,
							iRow,
							iCol,
							OnPreviewColor,
							OnAcceptColor);
		Chip.OnMouseEventDelegate = OnChildMouseEvent;
		// fancy anim in
		Chip.AnimateIn((iCol + iRow) * (class'UIUtilities'.const.INTRO_ANIMATION_DELAY_PER_INDEX / 2));
		ImageChips.AddItem(Chip);
	}

	//Save height to use for the mask/scrollbar comparison
	ChipHeight = GetChipY(iRow) + class'UISquadImage'.default.iDefaultSize;

	// Hook up navigation ---------------------------------------------
	for (iChip = 0; iChip < ImageChips.Length; iChip++)
	{
		Chip = ImageChips[iChip];

		LeftNavTargetChip = none;
		RightNavTargetChip = none;
		UpNavTargetChip = none;
		DownNavTargetChip = none;

		iLastRowLength = ImageChips.length % iMaxChipsPerRow;

		iOffset = iChip % iMaxChipsPerRow;

		// LEFT - RIGHT -------------------------------------------------
		if (Chip.Col == 0) // Left column
		{
			// In the last row, the left chip needs to wrap to the last chip,
			// regardless of width of that last row which may be an incomplete row.
			if (Chip.index >= ImageChips.Length - iMaxChipsPerRow)
				LeftNavTargetChip = ImageChips[ImageChips.length - 1];
			else
				LeftNavTargetChip = ImageChips[iChip + iMaxChipsPerRow - 1];
		}
		else if (Chip.Col == iMaxChipsPerRow - 1)// right column
			RightNavTargetChip = ImageChips[iChip - iMaxChipsPerRow + 1];
		else if ( Chip.index == ImageChips.length - 1)
			RightNavTargetChip = ImageChips[iChip - iLastRowLength + 1];


		if( LeftNavTargetChip == none )
			LeftNavTargetChip = ImageChips[iChip - 1];
		if( RightNavTargetChip  == none )
			RightNavTargetChip = ImageChips[iChip + 1];

		Chip.Navigator.AddNavTargetLeft(LeftNavTargetChip);
		Chip.Navigator.AddNavTargetRight(RightNavTargetChip);

		// UP - DOWN -------------------------------------------------

		if (Chip.Row == 0) // first row
		{
			if (iOffset >= iLastRowLength)
				UpNavTargetChip = ImageChips[ImageChips.Length - iLastRowLength - iMaxChipsPerRow + iOffset];
			else
				UpNavTargetChip = ImageChips[ImageChips.Length - iLastRowLength  + iOffset];
		}
		else if (Chip.index >= ImageChips.Length - iMaxChipsPerRow) // last edge, may wrap row
		{
			DownNavTargetChip = ImageChips[iOffset];
		}

		if (UpNavTargetChip == none)
			UpNavTargetChip = ImageChips[iChip - iMaxChipsPerRow];
		if (DownNavTargetChip == none)
			DownNavTargetChip = ImageChips[iChip + iMaxChipsPerRow];

		Chip.Navigator.AddNavTargetUp(UpNavTargetChip);
		Chip.Navigator.AddNavTargetDown(DownNavTargetChip);
	}

	RealizeMaskAndScrollbar();
	SetInitialSelection();
}

simulated function SetInitialSelection()
{
	if (ImageChips.Length > 0)
	{
		if (InitialSelection > -1 && InitialSelection < ImageChips.Length)
		{
			ChipContainer.Navigator.SetSelected(ImageChips[InitialSelection]);
		}
		else
		{
			ChipContainer.Navigator.SetSelected(ImageChips[0]);
		}
	}
	ScrollToRow(UISquadImage(ChipContainer.Navigator.GetSelected()).Row);
}

simulated function float GetChipX(int iCol)
{
	return ((class'UISquadImage'.default.iDefaultSize + ItemPadding) * iCol) + (EdgePadding);
}

simulated function float GetChipY(int iRow)
{
	return ((class'UISquadImage'.default.iDefaultSize + ItemPadding) * iRow) + (EdgePadding);
}


simulated function OnPreviewColor(int iIndex)
{
	if (OnPreviewDelegate != none)
		OnPreviewDelegate(iIndex);
}

simulated function OnAcceptColor(int iIndex)
{
	if (OnSetDelegate != none)
		OnSetDelegate(iIndex);
}

simulated function OnCancelColor()
{
	if (OnSetDelegate != none)
		OnSetDelegate(InitialSelection);
}

simulated function RealizeMaskAndScrollbar()
{
	if (ChipHeight > height)
	{
		if (Mask == none)
			Mask = Spawn(class'UIMask', self).InitMask();

		Mask.SetMask(ChipContainer);
		Mask.SetSize(width, height - EdgePadding * 2);
		Mask.SetPosition(0, EdgePadding);

		if (Scrollbar == none)
			Scrollbar = Spawn(class'UIScrollbar', self).InitScrollbar();

		Scrollbar.SnapToControl(Mask, -scrollbarPadding);
		Scrollbar.NotifyValueChange(ChipContainer.SetY, 5, 0 - ChipHeight + height - (EdgePadding * 2));
	}
	else
	{
		if (Mask != none)
		{
			Mask.Remove();
			Mask = none;
		}

		if (Scrollbar != none)
		{
			Scrollbar.Remove();
			Scrollbar = none;
		}
	}
}

simulated function OnChildMouseEvent(UIPanel control, int cmd)
{
	if (cmd == class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP)
		Scrollbar.OnMouseScrollEvent(-1);
	else if (cmd == class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN)
		Scrollbar.OnMouseScrollEvent(1);
}

simulated function OnSelectionIndexChanged(int Index)
{
	ScrollToRow(UISquadImage(ChipContainer.Navigator.GetSelected()).Row);
	OnPreviewColor(Index);
}

simulated function ScrollToRow(int iRow)
{
	local int MaxRow;
	MaxRow = ImageChips[ImageChips.Length - 1].Row;

	if (iRow < 0)
	{
		iRow = MaxRow;
	}

	if (iRow > MaxRow)
	{
		iRow = 0;
	}

	Scrollbar.SetThumbAtPercent(iRow / float(MaxRow));
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local UIPanel Chip;

	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
		return false;

	Chip = ChipContainer.Navigator.GetSelected();
	if (Chip != none && (Chip.Navigator.OnUnrealCommand(cmd, arg) || Chip.OnUnrealCommand(cmd, arg)))
	{
		return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}

defaultproperties
{
	bIsNavigable = true;
	bAnimateOnInit = false;
	bCascadeFocus = false;

	ItemPadding = 10;
	EdgePadding = 20;
	ScrollbarPadding = 30;
}
