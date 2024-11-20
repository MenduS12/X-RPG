#include <a_samp>
#include <a_mysql>
#include <samp_bcrypt>
#include <foreach>

#define DB_HOST "localhost"
#define DB_NAME "login"
#define DB_USER "root"
#define DB_PASS ""


enum
{
	DIALOG_ASK,
	DIALOG_REGISTER,
	DIALOG_LOGIN
};


enum pinfo
{
	MasterID,
	Skin,
	Level,

	bool:LoggedIn
};
new pInfo[MAX_PLAYERS][pinfo];

new MySQL:handle;



main()
{
	print("\n----------------------------------");
	print(" GAMEMODE BELAJAR ");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	handle = mysql_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
	
	if(mysql_errno(handle) == 0) printf("[MYSQL] Connection successful");
	else
	{
	    new error[100];
	    mysql_error(error, sizeof(error), handle);
		printf("[MySQL] Connection Failed : %s", error);
	}

	SetGameModeText("BELAJAR");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	foreach(new i : Player)
	{
			if(pInfo[i][LoggedIn]) SavePlayerData(i);
	}
	mysql_close(handle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new query[64];
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	mysql_format(handle, query, sizeof(query), "SELECT COUNT(Name) from `users` where Name = %s' ", pname);
	mysql_tquery(handle, query, "OnPlayerJoin", "d", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(pInfo[playerid][LoggedIn]) SavePlayerData(playerid);
	pInfo[playerid][LoggedIn] = false;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

SavePlayerData(playerid)
{
	new query[256], pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	mysql_format(handle, query, sizeof(query), "UPDATE `users` set Skin = %d, Level = %d WHERE Master_ID = %d", pInfo[playerid][Skin], pInfo[playerid][Level], pInfo[playerid][MasterID]);
	mysql_query(handle, query);
	printf("Saved %s's data", pname);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_REGISTER:
	    {
			if(response)
			{
			    bcrypt_hash(inputtext, 12, "OnPassHash", "d", playerid);
			}
			else Kick(playerid);
		}
		
		case DIALOG_LOGIN:
		{
			if(response)
			{
				new query[128], pname[MAX_PLAYER_NAME];
				GetPlayerName(playerid, pname, sizeof(pname));
    			SetPVarString(playerid, "Unhashed_Pass",inputtext);
				mysql_format(handle, query, sizeof(query), "SELECT password, Master_ID from `users` WHERE Name = '%s'", pname);
				mysql_tquery(handle, query, "OnPlayerLogin", "d", playerid);
			}
			else Kick(playerid);
		}
	}
	return 1;
}

forward OnPlayerJoin(playerid);
public OnPlayerJoin(playerid)
{
	new rows;
	cache_get_value_index_int(0, 0, rows);

	if(rows) ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "This account is found on your database. Please login", "Login", "Quit");

	else ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "This account not is found on your database. Please register", "Register", "Quit");
	return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	SendClientMessage(playerid, 0x0033FFFF /*Blue*/, "Thank you for registering! You can now Login");
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Thank you for registering! You can now Login with\npassword you just used to register.", "Login", "Quit");
	return 1;
}

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid)
{
	new pPass[255], unhashed_pass[128];
	GetPVarString(playerid, "Unhashed_Pass", unhashed_pass,sizeof(unhashed_pass));
	if(cache_num_rows())
	{
		cache_get_value_index(0, 0, pPass);
		cache_get_value_index_int(0, 1, pInfo[playerid][MasterID]);
		bcrypt_check(unhashed_pass, pPass, "OnPassCheck", "dd",playerid, pInfo[playerid][MasterID]);
	}
	else printf("ERROR ");
	return 1;
}

forward OnPassHash(playerid);
public OnPassHash(playerid)
{
	new pass[BCRYPT_HASH_LENGTH], query[128], pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    bcrypt_get_hash(pass);
    mysql_format(handle, query, sizeof(query), "INSERT INTO `users`(Name, Password) VALUES('%s', '%e')", pname, pass);
	mysql_tquery(handle, query, "OnPlayerRegister", "d", playerid);
	return 1;
}

forward OnPassCheck(playerid, DBID);
public OnPassCheck(playerid, DBID)
{
    if(bcrypt_is_equal())
	{
		SetPlayerInfo(playerid, DBID);
	}
	else ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "The password you just entered is wrong.\nPlease Try again!", "Login", "Quit");
	return 1;
}

SetPlayerInfo(playerid, dbid)
{
	new query[128];
	mysql_format(handle, query, sizeof(query), "SELECT Skin, Level FROM `users` WHERE Master_ID = %d", dbid);
	new Cache:result = mysql_query(handle, query);

	cache_get_value_index_int(0, 4, pInfo[playerid][Skin]);
	cache_get_value_index_int(0, 5, pInfo[playerid][Level]);

	pInfo[playerid][LoggedIn] = true;

	cache_delete(result);

	SetPlayerScore(playerid, pInfo[playerid][Level]);

	SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 0, 0, 0);

	TogglePlayerSpectating(playerid, false);
	TogglePlayerControllable(playerid, true);

	new name[MAX_PLAYER_NAME], str[80];
	GetPlayerName(playerid, name, sizeof(name));
	format(str, sizeof(str), "{00FF22}Welcome to the server, {FFFFFF}%s", name);
	SendClientMessage(playerid, -1, str);
	DeletePVar(playerid, "Unhashed_Pass");

	SpawnPlayer(playerid);
}


public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
