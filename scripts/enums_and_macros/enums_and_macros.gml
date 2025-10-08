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
#macro PARTICLE_LAYER "Particles"
#macro TILE_LAYER "Placement_Tiles"
#macro PROJECTILE_LAYER "Projectiles"
#macro TARGET_LAYER "Targets"
#macro UNIT_LAYER "Units"
#macro ENEMY_LAYER "Enemies"
#macro GROUND_INSTANCES_LAYER "Ground_Instances"
#macro CONTROLLER_LAYER "Controllers"
#endregion
//For easy iteration
global.INSTANCE_LAYERS = [TILE_LAYER, PROJECTILE_LAYER, TARGET_LAYER, UNIT_LAYER, ENEMY_LAYER, GROUND_INSTANCES_LAYER];

/*
	Macros for left and right directions.
	Based on what value is needed to flip the sprite in the correct direction using image_xscale
*/
#macro DIRECTION_LEFT 1
#macro DIRECTION_RIGHT -1

#macro SELL_PRICE_REDUCTION 0.8 //How much a unit sells for in comparison to how much it cost.

enum ENEMY_ATTACKING_STATE { //State that certain enemies use to determine whether they are in the middle of attacking or not
	NOT_ATTACKING,
	IN_ATTACK
}

enum CLOUD_STATE { //The state of the Cloud Construct's cloud summons
	TRAVELING_TO_TARGET,
	LINGERING,
	DISSIPATING,
}