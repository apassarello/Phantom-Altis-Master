#include <macro.h>
/*
	File: fn_requestReceived.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Called by the server saying that we have a response so let's
	sort through the information, validate it and if all valid
	set the client up.
*/
life_session_tries = life_session_tries + 1;
if(life_session_completed) exitWith {}; //Why did this get executed when the client already initialized? Fucking arma...
if(life_session_tries > 3) exitWith {cutText["There was an error in trying to setup your client.","BLACK FADED"]; 0 cutFadeOut 999999999;};

0 cutText ["Received request from server... Validating...","BLACK FADED"];
0 cutFadeOut 9999999;

//Error handling and  junk..
if(isNil "_this") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if(typeName _this == "STRING") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if(count _this == 0) exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if((_this select 0) == "Error") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if((getPlayerUID player) != _this select 0) exitWith {[] call SOCK_fnc_dataQuery;};

//Lets make sure some vars are not set before hand.. If they are get rid of them, hopefully the engine purges past variables but meh who cares.
if(!isServer && (!isNil "life_adminlevel" OR !isNil "life_coplevel" OR !isNil "life_donator")) exitWith {
	[[profileName,getPlayerUID player,"VariablesAlreadySet"],"SPY_fnc_cookieJar",false,false] spawn life_fnc_MP;
	[[profileName,format["Variables set before client initialization...\nlife_adminlevel: %1\nlife_coplevel: %2\nlife_donator: %3",life_adminlevel,life_coplevel,life_donator]],"SPY_fnc_notifyAdmins",true,false] spawn life_fnc_MP;
	sleep 0.9;
	["SpyGlass",false,false] execVM "\a3\functions_f\Misc\fn_endMission.sqf";
};


//Parse basic player information.
life_cash = parseNumber (_this select 2);
life_atmcash = parseNumber (_this select 3);
__CONST__(life_adminlevel,parseNumber(_this select 4));
__CONST__(life_donator,parseNumber(_this select 5));

//Loop through licenses
if(count (_this select 6) > 0) then {
	{missionNamespace setVariable [(_x select 0),(_x select 1)];} foreach (_this select 6);
};

life_gear = _this select 8;
[] spawn life_fnc_loadGear;

if(count (_this select 9) > 0) then {
{
missionNamespace setVariable [(_x select 0),[parseNumber (_x select 1), parseNumber (_x select 2)]];
} foreach (_this select 11);
};

//Parse side specific information.
switch(playerSide) do {
	case west: {
		__CONST__(life_coplevel,parseNumber(_this select 7));
		__CONST__(life_medicLevel,0);
		__CONST__(life_donatorlvl,parseNumber(_this select 5));
		life_blacklisted = _this select 9;
	};

	case civilian: {
		life_is_arrested = _this select 7;
		//life_is_arrested = call compile format["%1", _this select 7];
		__CONST__(life_coplevel,0);
		__CONST__(life_medicLevel,0);
		__CONST__(life_donatorlvl,parseNumber(_this select 5));

		civ_position = _this select 9;
		life_is_alive = _this select 10;

		life_houses = _this select 12;
		{
			_house = nearestBuilding (call compile format["%1", _x select 0]);
			life_vehicles pushBack _house;
		} foreach life_houses;

		life_gangData = _This select 13;
		if(count life_gangData != 0) then {
			[] spawn life_fnc_initGang;
		};
		[] spawn life_fnc_initHouses;

	};

	case independent: {
		__CONST__(life_medicLevel, parseNumber(_this select 7));
		__CONST__(life_copLevel,0);
		__CONST__(life_donatorlvl,parseNumber(_this select 5));
	};
};

switch(__GETC__(life_donator)) do
{
	case 1: {life_paycheck = life_paycheck + 400;};
	case 2: {life_paycheck = life_paycheck + 600;};
	case 3: {life_paycheck = life_paycheck + 1200;};
	case 4: {life_paycheck = life_paycheck + 1600;};
	case 5: {life_paycheck = life_paycheck + 2000;};
};

//Change (_this select 12) to (_this select 13) ?
if(count (_this select 14) > 0) then {
	{life_vehicles pushBack _x;} foreach (_this select 14);
};


life_session_completed = true;