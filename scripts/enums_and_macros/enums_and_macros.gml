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
#macro TILE_LAYER "Placement_Tiles"
#macro PROJECTILE_LAYER "Projectiles"
#macro TARGET_LAYER "Targets"
#macro UNIT_LAYER "Units"
#macro ENEMY_LAYER "Enemies"
#macro CONTROLLER_LAYER "Controllers"
#endregion


/*
	Macros for left and right directions.
	Based on what value is needed to flip the sprite in the correct direction using image_xscale
*/
#macro DIRECTION_LEFT 1
#macro DIRECTION_RIGHT -1
/*
enum DIRECTION {
	LEFT,
	RIGHT,
	UP, //Probably won't be used in the final game, kept for Sample Brawler
	DOWN //Probably won't be used in the final game, kept for Sample Brawler
}*/

#macro SELL_PRICE_REDUCTION 0.8 //How much a unit sells for in comparison to how much it cost.