//Ignore most of this for now.

/*
	data_enemy.gml
	
	This file contains data for all the different types of enemies in the game.
	Sometimes, we might need to refer to some stats that an enemy has before initializing any instances of that enemy (ex. looking at an enemy descriptions)
	This data can be used to refer to enemies in these instances.
	This data is also used when the corresponding enemy is created
*/

/*
	Data that all enemies should have
	obj: The corresponding object that is spawned with this data
	name: What the enemy is referred to
	max_health: The maximum amount of health this enemy normally has
	current_health: The health that the enemy is currently has. Normally initialized to the same value as max_health.
	monetary_value: The amount of money this enemy gives upon defeat
	movement_path: The path that the enemy follows. Usually given to the enemy by a spawner.
	movement_speed: How quickly the enemy moves along it's given path
	round_spawned_in: A pointer to the Round object that spawned the enemy. Needed to call back into the round when it gets destroyed
	enemy_buffs: An array of all the buffs/debuffs the enemy has
*/
/*
function BaseEnemyData(_obj, _name, _max_health, _monetary_value, _round_spawned_in, _current_health = _max_health, _movement_path = pth_dummypath, _movement_speed = 0, _enemy_buffs = []) constructor{
	obj = _obj;
	name = _name;
	
	max_health = _max_health;
	current_health = _current_health;
	
	monetary_value = _monetary_value;
	
	movement_path = _movement_path;
	movement_speed = _movement_speed;
	
	round_spawned_in = _round_spawned_in;
	enemy_buffs = _enemy_buffs;

}

function SampleEnemyData(): BaseEnemyData(
	_obj = sample_enemy,
	_name = "Sample Enemy",
	) constructor {
	
}
*/

/*
	Whether an enemy should be moving or attacking
*/
enum ENEMY_ATTACKING_STATE {
	NOT_ATTACKING,
	IN_ATTACK
}