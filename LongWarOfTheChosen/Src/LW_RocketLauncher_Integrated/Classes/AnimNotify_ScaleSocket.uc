class AnimNotify_ScaleSocket extends AnimNotify_Scripted;

var() name Socket;
var() float Scale;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComUnitPawn Pawn;
	local int i;
	
	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		for (i=0; i < Pawn.Mesh.Sockets.Length; i++)
		{
			if (Pawn.Mesh.Sockets[i].SocketName == Socket)
			{
				Pawn.Mesh.Sockets[i].RelativeScale.X = Scale;
				Pawn.Mesh.Sockets[i].RelativeScale.Y = Scale;
				Pawn.Mesh.Sockets[i].RelativeScale.Z = Scale;
				return;
			}
		}
    }
}