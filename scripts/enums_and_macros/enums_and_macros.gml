/*
	enums_and_macros.gml
	This file contains macros and enums that don't fit in any other particular script file.
	Mainly used for those that appear everywhere.
*/


#region Distance Macros
#macro TILE_SIZE 64 //Basis for all tile math and such (ex. unit radius is based on this number)

#macro DIST_OFF_SCREEN 64 //How far an object has to be off screen before it will be destroyed
#endregion


#region Room Layer Macros
#macro MENU_LAYER "Menus"
#macro TILE_LAYER "Placement_Tiles"
#macro PROJECTILE_LAYER "Projectiles"
#macro UNIT_LAYER "Units"
#macro ENEMY_LAYER "Enemies"
#macro CONTROLLER_LAYER "Controllers"
#endregion


/*
	Enums for different directions
*/
enum DIRECTION {
	UP,
	DOWN,
	LEFT,
	RIGHT
}


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
}