/*
	buffs_and_debuffs.gml
	
	This file contains information for unit and enemy buffs and debuffs.
	
	
*/

/*
	Enums for different kinds of buffs.
	Buffs consists of one of these types and a multiplier
		- 1 < x multiplier indicates a buff
		- 0 < x < 1 multiplier indicates a debuff
*/
enum BUFF_TYPE {
	RANGE, //Alters size of range
	MOVEMENT_SPEED, //Alters movement speed of unit/enemy
	SHOOTING_SPEED, //Alters shooting speed of unit/enemy
	DEFENSE, //Alters unit/enemy defense
	HEALTH_REGEN, //Alters unit/enemy health regen speed
	MONEY,
}

//TODO: Is this how I want to do buffs? Or should I just use a table with
function GrantedBuff(_buff_giver_id, _buff_type, _multiplier) {
}