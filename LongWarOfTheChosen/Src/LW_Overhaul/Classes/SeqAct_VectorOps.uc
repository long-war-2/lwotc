//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_VectorOps.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Operations on N vectors. Inputs an arbitrary number of vectors and/or vector
//           lists and computes the sum and average of the members.
//---------------------------------------------------------------------------------------

class SeqAct_VectorOps extends SequenceAction;

var private Vector Sum;
var private Vector Average;
var private int Count;

event Activated() 
{
	local SeqVar_VectorList VectorList;
	local SeqVar_Vector V;
	local int i;

	foreach LinkedVariables(class'SeqVar_VectorList', VectorList, "Vector List")
	{
		for (i = 0; i < VectorList.arrVectors.Length; ++i)
		{
			Sum += VectorList.arrVectors[i];
			++Count;
		}
	}

	foreach LinkedVariables(class'SeqVar_Vector', V, "Vector")
	{
		Sum += V.VectValue;
		++Count;
	}

	Average = Sum / Count;
}

defaultproperties
{
    ObjName="Vector Ops"
	ObjCategory="LWOverhaul"

    bConvertedForReplaySystem=true
    bCanBeUsedForGameplaySequence=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Vector")
    VariableLinks(1)=(ExpectedType=class'SeqVar_VectorList',LinkDesc="Vector List")
    VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Sum",PropertyName=Sum,bWriteable=true)
    VariableLinks(3)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Average",PropertyName=Average,bWriteable=true)
    VariableLinks(4)=(ExpectedType=class'SeqVar_Int',LinkDesc="Count",PropertyName=Count,bWriteable=true)
}
 
