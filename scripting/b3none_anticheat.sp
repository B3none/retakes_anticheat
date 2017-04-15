/*
/ Optimisations by Xines http://steamcommunity.com/profiles/76561197996957454
/ Code written by B3none http://steamcommunity.com/profiles/76561198028510846
/*

#include <sourcemod>
#include <sdktools>

int i_HeadshotKillCount[MAXPLAYERS+1];
ConVar b3none_ac_enabled;
ConVar b3none_ac_kill_limit;
ConVar b3none_ac_ban_time;

public Plugin myinfo = 
{
    name =            "[Retakes] Anticheat Blatent",
    author =         "B3none",
    description =    "This should catch all of the blatent cheaters.",
    version =         "1.1.5",
    url =             "www.voidrealitygaming.co.uk"
};

public void OnPluginStart()
{
    b3none_ac_enabled = CreateConVar("b3none_ac_enabled", "1", "Enable = 1 | Disable = 0", _, true, 0.0, true, 1.0);
    b3none_ac_kill_limit = CreateConVar("b3none_ac_kill_limit", "30", "How many Headshots must the client get?");
    b3none_ac_ban_time = CreateConVar("b3none_ac_ban_time", "10080", "How long should the convicted client be banned? (Minutes)");
    
    HookEvent("player_death", Hook_PlayerDeath);
}

public void OnClientPostAdminCheck(int client)
{
    i_HeadshotKillCount[client] = 0;
}

public Action Hook_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    if(!b3none_ac_enabled.BoolValue) return Plugin_Continue;
    
    int Attacker = GetClientOfUserId(event.GetInt("attacker"));
    if(IsValidClient(Attacker))
    {
        if (event.GetBool("headshot")) i_HeadshotKillCount[Attacker]++;
        else i_HeadshotKillCount[Attacker] = 0;

        if(i_HeadshotKillCount[Attacker] == b3none_ac_kill_limit.IntValue)
        {
            ServerCommand("sm_ban %N %i", Attacker, b3none_ac_ban_time.IntValue);
            KickClient(Attacker, "You were permanently banned from the server.");
            PrintToChatAll("[\x0CB3none_Anticheat\x01] \x02Hacker\x01 %N detected.", Attacker);
        }
    }
    return Plugin_Continue;
}

/** Stocks **/
stock bool IsValidClient(int client)
{
    return (1 <= client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client));
} 
