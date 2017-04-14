#include <sourcemod>
#include <sdktools>

int i_HeadshotKillCount[MAXPLAYERS+1];

public Plugin myinfo = 
{
	name = 			"[Retakes] Anticheat Blatent",
	author = 		"B3none",
	description = 	"This should catch all of the blatent cheaters.",
	version = 		"0.0.1",
	url = 			"www.voidrealitygaming.co.uk"
};

public void OnPluginStart()
{
	HookEvent("player_death", Hook_PlayerDeath);
}

public Hook_PlayerDeath(Handle death, const String:name[], bool:DontBroadcast)
{
    new Attacker = GetEventInt(death, "attacker");
	bool b_headshot = GetEventBool(death, "headshot");
	
	if(b_headshot == true)
	{
		i_HeadshotKillCount[Attacker] = i_HeadshotKillCount[Attacker] +1;
	}
	
	if(i_HeadshotKillCount[Attacker] == 30)
	{
		Command_Ban(Attacker);
	}
}

Command_Ban(int Attacker)
{
	char ban_hacker[512];
	
	Format(ban_hacker, sizeof(ban_hacker), "sm_ban %s -1", Attacker);
	ServerCommand(ban_hacker);
	PrintToChatAll("[\x0CB3none_Anticheat\x01] \x02Hacker\x01 detected.");
}

public OnClientDisconnect()
{
	char sUserId[64];
	int iClient = GetClientOfUserId(StringToInt(sUserId));
	
	i_HeadshotKillCount[iClient] = 0;
}

public OnMapEnd()
{
	for(int i=1; i<=MAXPLAYERS+1; i++)
	{
		i_HeadshotKillCount[i] = 0;
	}
}
