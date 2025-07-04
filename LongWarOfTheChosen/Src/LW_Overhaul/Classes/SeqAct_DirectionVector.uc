//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_DirectionVector.uc
//  AUTHOR:  Tedster
//  PURPOSE: Takes in 2 vectors and a multiplier, gives you a vector defining a point on
//           the line between the two vectors, distance proportional to the multiplier.
//---------------------------------------------------------------------------------------

class SeqAct_DirectionVector extends SequenceAction;

var private Vector OutVector;
var private float Multiplier;

var private Vector StartVector;
var private Vector EndVector;

event Activated() 
{
    `LWTrace("Start vector:" @ StartVector.X @StartVector.Y @StartVector.Z);
    `LWTrace("End Vector:" @EndVector.X @EndVector.Y @EndVector.Z);

    OutVector = VLerp(StartVector, EndVector, Multiplier);

    `LWTrace("OutVector:" @ OutVector.X @OutVector.Y @OutVector.Z);
}

defaultproperties
{
    ObjName="Direction Vector"
	ObjCategory="LWOverhaul"

    bConvertedForReplaySystem=true
    bCanBeUsedForGameplaySequence=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Start Vector", PropertyName=StartVector)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="End Vector", PropertyName=EndVector)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Multiplier",PropertyName=Multiplier)
    VariableLinks(3)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Output Point",PropertyName=OutVector,bWriteable=true)
}