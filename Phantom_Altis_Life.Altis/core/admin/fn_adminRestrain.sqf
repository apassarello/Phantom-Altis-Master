/*
	File: fn_restrainAction.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Retrains the target.
*/
private["_unit"];

if((call life_adminlevel) < 1) exitWith {closeDialog 0; hint localize "STR_ANOTF_ErrorLevel";};

//_unit = cursorTarget;
_unit = lbData[1500,lbCurSel (1500)];
_unit = call compile format["%1", _unit];


if(isNull _unit) exitWith {}; //Not valid


if((_unit getVariable "restrained")) exitWith {};
//if(side _unit == west) exitWith {};
//if(player == _unit) exitWith {};
if(!isPlayer _unit) exitWith {};
//Broadcast!

_unit setVariable["restrained",true,true];
[[player], "life_fnc_restrain", _unit, false] spawn life_fnc_MP;

hint format["%1 restrained.", name _unit];