// this class provides transparent access to the PointInSpaces, CameraActors etc. that are required for the mod to function
// it serves both as a serializer and deserializer: when the actor is present, serialize. If the actor isn't present, use cached data
// apparently that doesn't work, so if you want to save, change the config file, save actors, copy null config into present config, delete nullconfig
class robojumper_SquadSelect_WorldConfiguration extends Object config(robojumperSquadSelect_World);


struct ActorPlacement
{
	var name ActorTag;
	var vector ActorLocation;
	var rotator ActorRotation;
	var name ActorClass;
};

// we can't spawn PointInSpace but have to use DynamicPointInSpace
// we can't spawn CameraActor but have to use DynamicCameraActor
struct DynamicOverride
{
	var name OrigClassName;
	var name DynamicClassName;
};

var config array<ActorPlacement> PlacementData;
var config array<DynamicOverride> ClassOverrides;


static function Actor GetTaggedActor(name ActorTag, optional class<Actor> SearchClass = class'Actor')
{
	local Actor TestActor;
	local int i;
	local class<Actor> SpawnClass;

	foreach `XWORLDINFO.AllActors(SearchClass, TestActor)
	{
		if (TestActor.Tag == ActorTag)
		{
			return TestActor;
		}
	}
	// The actor isn't present. Spawn it using cached data
	for (i = 0; i < default.PlacementData.Length; i++)
	{
		if (default.PlacementData[i].ActorTag == ActorTag)
		{
			SpawnClass = class<Actor>(class'Engine'.static.FindClassType(string(default.PlacementData[i].ActorClass)));	// class<Actor>(DynamicLoadObject(string(default.PlacementData[i].ActorClass), class'Class'));
			OverrideClass(SpawnClass);
			TestActor = `XWORLDINFO.Spawn(SpawnClass, , default.PlacementData[i].ActorTag, default.PlacementData[i].ActorLocation, default.PlacementData[i].ActorRotation);
			// HAX / HACK: no idea how to do it properly
			if (CameraActor(TestActor) != none)
			{
				CameraActor(TestActor).FOVAngle = 70;
			}
			return TestActor;
		}
	}
	return none;
}

static function OverrideClass(out class<Actor> TheClass)
{
	local int idx;
	
	idx = default.ClassOverrides.Find('OrigClassName', name(string(TheClass)));
	if (idx == INDEX_NONE)
	{
		
	}
	if (idx != INDEX_NONE)
	{
		
		TheClass = class<Actor>(class'Engine'.static.FindClassType(string(default.ClassOverrides[idx].DynamicClassName)));	// class<Actor>(DynamicLoadObject(string(default.ClassOverrides[idx].DynamicClassName), class'Class'));
	}
}

static function SaveActor(Actor TheActor)
{
	local int idx;
	local ActorPlacement EmptyData;
	local robojumper_SquadSelect_WorldConfiguration ConfigInstance;

	ConfigInstance = new class'robojumper_SquadSelect_WorldConfiguration';
	idx = ConfigInstance.PlacementData.Find('ActorTag', TheActor.Tag);
	if (idx == INDEX_NONE)
	{
		idx = ConfigInstance.PlacementData.Length;
		ConfigInstance.PlacementData.AddItem(EmptyData);
	}
	ConfigInstance.PlacementData[idx].ActorTag = TheActor.Tag;
	ConfigInstance.PlacementData[idx].ActorLocation = TheActor.Location;
	ConfigInstance.PlacementData[idx].ActorRotation = TheActor.Rotation;
	ConfigInstance.PlacementData[idx].ActorClass = name(PathName(TheActor.Class) $ "." $ string(TheActor.Class));

	ConfigInstance.SaveConfig();
}