#include <sourcemod>

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

public Hook_PlayerDeath(Handle death, const char name[], bool:DontBroadcast)
{
    char attacker[32] = GetEventInt(death, "attacker");
	bool b_headshot = GetEventBool(death, "headshot");
	
	if(b_headshot == true)
	{
		i_HeadshotKillCount[attacker] = i_HeadshotKillCount[attacker] +1;
	}
	
	if(i_HeadshotKillCount[attacker] == 30)
	{
		ServerCommand("sm_ban %i -1");
	}
}

public OnClientDisconnect()
{
	i_HeadshotKillCount[client] = 0;
}

public OnMapEnd()
{
	for(int i=1; i<=MAXPLAYERS+1; i++)
	{
		i_HeadshotKillCount[i] = 0;
	}
}
