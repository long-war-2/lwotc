interface MCM_API;

enum eGameMode
{
    eGameMode_MainMenu,
    eGameMode_Strategy,
    eGameMode_Tactical,
    eGameMode_Multiplayer,
    eGameMode_Unknown
};

// Using an int means that we don't have to redefine eGameMode if we add more possible future values.
delegate ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode);

// major and minor versions required in order to enforce compatibility constraints.
function bool RegisterClientMod(int major, int minor, delegate<ClientModCallback> SetupHandler);