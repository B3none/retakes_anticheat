#include <sourcemod>
#include <sdktools>
#include <csgocolors>

int i_HeadshotKillCount[MAXPLAYERS+1];

ConVar	b3none_ac_enabled;
ConVar	b3none_ac_kill_limit;
ConVar	b3none_ac_ban_time;

public Plugin myinfo = 
{
	name = 			"[Retakes] Anticheat Blatent",
	author = 		"B3none",
	description = 		"This should catch all of the blatent cheaters.",
	version = 		"1.1.4",
	url = 			"www.voidrealitygaming.co.uk"
};

public void OnPluginStart()
{
	b3none_ac_enabled = CreateConVar("b3none_ac_enabled", "1.0", "Enable = 1.0 | Disable = 0.0", _, true, 0.0, true, 1.0);
	b3none_ac_kill_limit = CreateConVar("b3none_ac_kill_limit", "30", "How many Headshots must the client get?");
	b3none_ac_ban_time = CreateConVar("b3none_ac_ban_time", "604800", "How long should the convicted client be banned? (Seconds)");
	
	if(GetConVarBool(b3none_ac_enabled))
	{
		HookEvent("player_death", Hook_PlayerDeath);
	}
	
	else{return;}
}

public Hook_PlayerDeath(Handle death, const String:name[], bool:DontBroadcast)
{
	new Attacker = GetEventInt(death, "attacker");
	bool b_headshot = GetEventBool(death, "headshot");
	
	if(b_headshot == true)
	{
		i_HeadshotKillCount[Attacker] = i_HeadshotKillCount[Attacker] +1;
	}
	
	if(!b_headshot == true)
	{
		i_HeadshotKillCount[Attacker] = 0;
	}
	
	if(i_HeadshotKillCount[Attacker] == GetConVarFloat(b3none_ac_kill_limit))
	{
		char ban_hacker[512];
		char kick_hacker[512];
		char ban_message[512];
		char client_to_ban[512];
		
		new Attacker_new = GetClientOfUserId(Attacker);
		GetClientName(Attacker_new, client_to_ban, sizeof(client_to_ban));
		
		Format(ban_hacker, sizeof(ban_hacker), "sm_ban %s %s", client_to_ban, GetConVarFloat(b3none_ac_ban_time)); // Ban offender
		ServerCommand(ban_hacker);
		
		if(IsValidClient(Attacker))
		{
			Format(kick_hacker, sizeof(kick_hacker), "sm_kick %s", client_to_ban); // Kicked after ban.
			ServerCommand(kick_hacker);
		}

		Format(ban_message, sizeof(ban_message), "[\x0CB3none_Anticheat\x01] \x02Hacker\x01 %s detected.", client_to_ban); // Public shame
		PrintToChatAll(ban_message);
	}
}

public OnClientDisconnect(int Attacker)
{
	i_HeadshotKillCount[Attacker] = 0;
}

public OnMapEnd()
{
	for(int i=1; i<=MAXPLAYERS+1; i++)
	{
		i_HeadshotKillCount[i] = 0;
	}
}

bool IsValidClient(int Attacker)
{
    if (!(0 < Attacker <= MaxClients)) return false;
    if (!IsClientInGame(Attacker)) return false;
    if (IsFakeClient(Attacker)) return false;
    return true;
} 
