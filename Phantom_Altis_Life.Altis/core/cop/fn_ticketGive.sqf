/*
	File: fn_ticketGive.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Gives a ticket to the targeted player.
*/
private["_val"];
if(isNil {life_ticket_unit}) exitWith {hint "Person to ticket is nil"};
if(isNull life_ticket_unit) exitWith {hint "Person to ticket doesn't exist."};
_val = ctrlText 2652;
if(!([_val] call TON_fnc_isnumber)) exitWith {hint "You didn't enter actual number format."};
if((parseNumber _val) > 999999) exitWith {hint "Tickets can not be more than $999,999!"};
[[0,format["%1 gave a ticket of $%2 to %3",profileName,[(parseNumber _val)] call life_fnc_numberText,life_ticket_unit getVariable["realname",name life_ticket_unit]]],"life_fnc_broadcast",true,false] spawn life_fnc_MP;
player say3D "ticket";
[[player,(parseNumber _val)],"life_fnc_ticketPrompt",life_ticket_unit,false] spawn life_fnc_MP;
closeDialog 0;