// Spawned by the engine when XCOM 2 runs with -AutoTest -AutoTestClass=X2TestHarness.X2TH_AutoTestMgr.
// At the main menu it runs each class in TestClasses, logs results to Launch.log, and exits the game.
class X2TH_AutoTestMgr extends AutoTestManager config(X2TestHarness);

var config array<string> TestClasses;
var config float SettleSeconds;

var int Passed, Failed;

event PostBeginPlay()
{
	super.PostBeginPlay();
	if (XComShell(WorldInfo.Game) != none)
		SetTimer(SettleSeconds, false, nameof(RunTests));
}

function RunTests()
{
	local string ClassName;
	local class<X2TH_Test> TestClass;
	local X2TH_Test Test;

	foreach TestClasses(ClassName)
	{
		Say("RUN" @ ClassName);
		TestClass = class<X2TH_Test>(DynamicLoadObject(ClassName, class'Class'));
		if (TestClass == none)
		{
			Check(false, "test class loads");
			continue;
		}
		Test = new TestClass;
		Test.T = self;
		Test.Run();
	}
	Say("SUMMARY passed=" $ Passed @ "failed=" $ Failed);
	ConsoleCommand("exit");
}

function Check(bool bOk, string CheckName)
{
	if (bOk)
	{
		Passed++;
		Say("PASS" @ CheckName);
	}
	else
	{
		Failed++;
		Say("FAIL" @ CheckName);
	}
}

function Say(string Msg)
{
	`log("X2TH" @ Msg,, 'X2TH');
}
