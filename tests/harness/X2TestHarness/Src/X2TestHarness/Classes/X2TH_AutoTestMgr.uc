// Spawned by the engine when XCOM 2 runs with -AutoTest -AutoTestClass=X2TestHarness.X2TH_AutoTestMgr.
// At the main menu it loads the save named by SaveName; on the Geoscape it runs each class in TestClasses,
// logs results to Launch.log, and exits the game.
class X2TH_AutoTestMgr extends AutoTestManager config(X2TestHarness);

var config array<string> TestClasses;
var config float SettleSeconds;
var config string SaveName;

var int LoadAttempts;
var int Passed, Failed;

event PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(0.5, true);
}

event Timer()
{
	if (XComShell(WorldInfo.Game) != none)
		RequestLoad();
	else if (`HQPRES != none && `HQPRES.ScreenStack.GetCurrentScreen() != none)
	{
		ClearTimer();
		SetTimer(SettleSeconds, false, nameof(RunTests));
	}
}

function RequestLoad()
{
	local XComOnlineEventMgr EventMgr;
	local int SaveID;

	EventMgr = `ONLINEEVENTMGR;
	if (EventMgr.bAutoTestLoad)
		return;

	SaveID = EventMgr.SaveNameToID(SaveName);
	if (SaveID < 0)
	{
		if (LoadAttempts++ == 20)
			Say("save not found:" @ SaveName);
		return; // the save list may not be ready yet
	}

	Say("loading" @ SaveName);
	EventMgr.bAutoTestLoad = true;
	EventMgr.LoadGame(SaveID);
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
