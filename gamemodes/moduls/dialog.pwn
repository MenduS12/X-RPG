Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if(!response) 
		return Kick(playerid);

	new str[256];
	format(str, sizeof(str), "Welcome to %s\nName: %s\nERROR: Password length cannot below 7 or above 32!\nPlease insert your Password below to register", SERVER_NAME, GetName(playerid));

    if(strlen(inputtext) < 7)
		return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", str, "Register", "Quit");

    if(strlen(inputtext) > 32)
		return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", str, "Register", "Quit");

    bcrypt_hash(playerid, "HashPlayerPassword", inputtext, BCRYPT_COST);
	return 1;
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(!response)
	    return Kick(playerid);
	        
    if(strlen(inputtext) < 1)
    {
		new string[256];
        format(string, sizeof(string), "Welcome Back to %s.\nName: %s\nType your password below to login.", SERVER_NAME, GetName(playerid));
        Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Quit");
        return 1;
	}
	new pwQuery[256], hash[BCRYPT_HASH_LENGTH];
	mysql_format(sqlcon, pwQuery, sizeof(pwQuery), "SELECT Password FROM Account WHERE Name = '%e' LIMIT 1", GetName(playerid));
	mysql_query(sqlcon, pwQuery);
		
    cache_get_value_name(0, "Password", hash, sizeof(hash));
        
    bcrypt_verify(playerid, "OnPlayerPasswordChecked", inputtext, hash);
	return 1;
}
