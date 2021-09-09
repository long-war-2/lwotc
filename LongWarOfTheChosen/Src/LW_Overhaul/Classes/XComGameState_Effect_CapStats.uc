//-----------------------------------------------------------
//	Class:	XComGameState_Effect_CapStats
//	Author: Musashi
//  PURPOSE: Effect State containing stat caps
//-----------------------------------------------------------
class XComGameState_Effect_CapStats extends XComGameState_Effect dependson(X2Effect_Unstoppable);

var array<StatCap>  m_aStatCaps;


function AddCap(StatCap Cap)
{
	m_aStatCaps.AddItem(Cap);
}
