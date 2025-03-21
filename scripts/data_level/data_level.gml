/*
	data_level.gml
	
	This file contains metadata for the levels within the game.
	Each level controller inherits the base game controller, which declares all of the data needed to run all levels.
	Then, each level initializes its unique properties after that code is run.
*/
#region Data Constructors

#region PathData (Class)
/*
	Contains all of the data for a "path" with a spawner and a default movement path
	
	Argument Variables:
	Correspond to Data Variables
	
	Data Variables:
	spawn_x: The x-coordinate of where enemies should spawn from
	spawn_y: The y-coordinate of where enemies should spawn from
	default_path: The path that enemies without a specific path defined for them will use when spawned 
*/
function PathData(_spawn_x, _spawn_y, _default_path) constructor {
	spawn_x = _spawn_x;
	spawn_y = _spawn_y;
	default_path = _default_path;
	
	static toString = function() { //For debug purposes
		return "Spawn Coordinates: (" + string(spawn_x) + ", " + string(spawn_y) + ")\nDefault Path: " + string(default_path)
	}
}
#endregion

#region LevelData (Class)
/*
	A struct that contains all of the unique data for a level.
	
	Argument Variables:
	_basic_level_data: A struct containing all of the numerical and text values needed for the level
	The rest correspond to Data Variables
	
	Data Variables:
	round_data: A 2D array containing all of the enemies (2nd dimension) that spawn in a round (1st dimension)
	defense_health: The amount of health the structure(s) you are defending has.
	
	TODO: Include purchasing data and starting money here? Or will these defined in some sort of player structure if the player is allowed to determine those?
*/
function LevelData(_basic_level_data = {}, 
					_round_data = []) constructor {
						
	round_data = _round_data;
}
#endregion

#endregion


#region Data Definitions

#region Path Data
global.DATA_LEVEL_PATH_SAMPLELEVEL1_1 = new PathData(TILE_SIZE*-1, TILE_SIZE*7, pth_spawn1_SampleLevel1)

global.DATA_LEVEL_PATH_SAMPLELEVEL2_1 = new PathData(TILE_SIZE*-1, TILE_SIZE*5, pth_spawn1_SampleLevel2)
global.DATA_LEVEL_PATH_SAMPLELEVEL2_2 = new PathData(TILE_SIZE*-1, TILE_SIZE*6, pth_spawn2_SampleLevel2)
#endregion

#region Level Data
//TODO: Round data is ok to read for these sample levels, but I can tell it's gonna be a pain to read with actual levels. Think of the best way to manage this
global.DATA_LEVEL_MAIN_SAMPLELEVEL1 = new LevelData({},
	[
		[
			new EnemySpawningData([sample_enemy], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([sample_enemy], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([sample_enemy], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], ENEMY_SPAWN_END, 10, 5)
		]
	]
);

global.DATA_LEVEL_MAIN_SAMPLELEVEL2 = new LevelData({},
	[
		[
			new EnemySpawningData([sample_enemy], [global.DATA_LEVEL_PATH_SAMPLELEVEL2_1], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([sample_enemy], [global.DATA_LEVEL_PATH_SAMPLELEVEL2_2], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([sample_enemy, sample_enemy], [global.DATA_LEVEL_PATH_SAMPLELEVEL2_1, global.DATA_LEVEL_PATH_SAMPLELEVEL2_2], ENEMY_SPAWN_END, 10, 5)
		]
	]
);
#endregion

#endregion