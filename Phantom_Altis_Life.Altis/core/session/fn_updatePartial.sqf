#include <macro.h>
/*
	Author: Bryan "Tonic" Boardwine

	Description:
	Sends specific information to the server to update on the player,
	meant to keep the network traffic down with large sums of data flowing
	through life_fnc_MP
*/
private["_mode","_packet","_array","_flag","_civPosition"];
_mode = [_this,0,0,[0]] call BIS_fnc_param;
_packet = [steamid,playerSide,nil,_mode];
_array = [];
_flag = switch(playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"};};

switch(_mode) do {
	case 0: {
		_packet set[2,life_cash];
	};

	case 1: {
		_packet set[2,life_atmcash];
	};

	case 2: {
		{
			if(_x select 1 == _flag) then
			{
				_array pushBack [_x select 0,(missionNamespace getVariable (_x select 0))];
			};
		} foreach life_licenses;

		_packet set[2,_array];
	};

	case 3: {
		[] call life_fnc_saveGear;
		_packet set[2,life_gear];
	};

	case 4: {
		_packet set[2,life_is_alive];
	};

	case 5: {
		_packet set[2,life_is_arrested];
	};

	case 6: {
		_packet set[2,life_cash];
		_packet set[4,life_atmcash];
	};

	case 7: {
		//key management
	};

	case 8: {
		_civPosition = getPos player;
		_packet set[2,_civPosition];
	};

	case 9: {
		_packet set[2,life_gear];

		switch(_side) do {
			case west: {_packet set[2,cop_prof];};
			case civilian: {_packet set[2,civ_prof];};
			case independent: {_packet set[2,med_prof];};
		};
	};

};

[_packet,"DB_fnc_updatePartial",false,false] call life_fnc_MP;