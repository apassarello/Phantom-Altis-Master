#include <macro.h>
/*
	File: fn_useItem.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Main function for item effects and functionality through the player menu.
*/
private["_item","_cops"];
disableSerialization;
if((lbCurSel 2005) == -1) exitWith {hint "You need to select an item first!";};
_item = lbData[2005,(lbCurSel 2005)];

switch (true) do
{
	case (_item == "water" or _item == "coffee"):
	{
		if(([false,_item,1] call life_fnc_handleInv)) then
		{
			life_thirst = 100;
			player setFatigue 0;
		};
	};
	
	case (_item == "boltcutter"): {
		[cursorTarget] spawn life_fnc_boltcutter;
		closeDialog 0;
	};
	
	case (_item == "blastingcharge"): {
		//need 4+ cops to rob vault.
		_cops = 0;
		{if(side _x == west) then {_cops = _cops + 1;}} foreach playableUnits; 
		if(_cops > 4) then {
			player reveal fed_bank;
			(group player) reveal fed_bank;
			[cursorTarget] spawn life_fnc_blastingCharge;
		} else {
			hint "More cops must be online to rob the federal reserve."
		};
	};
	
	case (_item == "defusekit"): {
		[cursorTarget] spawn life_fnc_defuseKit;
	};
	
	case (_item in ["storagesmall","storagebig"]): {
		if(__GETC__(life_donator) > 0) then
		{
			[_item] call life_fnc_storageBox;
		} else {
			hint "You must be a donator to use storage crates.";
		};
		
		
	};
	case (_item == "redgull"):
	{
		if(([false,_item,1] call life_fnc_handleInv)) then
		{
			life_thirst = 100;
			player setFatigue 0;
			[] spawn
			{
				life_redgull_effect = time;
				titleText["You can now run farther for 3 minutes","PLAIN"];
				player enableFatigue false;
				waitUntil {!alive player OR ((time - life_redgull_effect) > (3 * 60))};
				player enableFatigue true;
			};
		};
	};
	
	case (_item == "spikeStrip"):
	{
		if(!isNull life_spikestrip) exitWith {hint "You already have a Spike Strip active in deployment"};
		if(([false,_item,1] call life_fnc_handleInv)) then
		{
			[] spawn life_fnc_spikeStrip;
		};
	};
	
	case (_item == "fuelF"):
	{
		if(vehicle player != player) exitWith {hint "You can't refuel the vehicle while in it!"};
		[] spawn life_fnc_jerryRefuel;
	};
	
	case (_item == "lockpick"):
	{
		[] spawn life_fnc_lockpick;
	};
	
	case (_item in ["apple","rabbit","salema","ornate","mackerel","tuna","mullet","catshark","turtle","turtlesoup","donuts","tbacon","peach"]):
	{
		[_item] call life_fnc_eatFood;
	};

	case (_item == "pickaxe"):
	{
		[] spawn life_fnc_pickAxeUse;
	};
	
	case (_item == "underwatercharge"): {
		player reveal gold_safe;
		(group player) reveal gold_safe;
		[cursorTarget] spawn life_fnc_underwaterCharge;
	};
	
	case (_item == "kidney"):
	{
		if(([false,_item,1] call life_fnc_handleInv)) then
		{
			player setVariable["missingOrgan",false,true];
			life_thirst = 100;
			life_hunger = 100;
			player setFatigue .5;
		};
	};
	
	default
	{
		hint "This item isn't usable.";
	};
};
	
[] call life_fnc_p_updateMenu;
[] call life_fnc_hudUpdate;