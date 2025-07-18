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
	percentage_per_tile: The percentage of the path one tile should take up. Used for path calculations.
*/
function PathData(_spawn_x, _spawn_y, _default_path) constructor {
	spawn_x = _spawn_x;
	spawn_y = _spawn_y;
	default_path = _default_path;
	
	//NOTE: This is wrong, because not all tiles take up the same amount of path (a corner tile will take up two 64-piece segments, while a straightway will only take up one
	//TODO: Instead of relying on something like this, just update the Worm King's code to have a "tile-to-spawn-worm-hole" on variable
	percentage_per_tile = TILE_SIZE / path_get_length(_default_path);
	
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
		- level_room: The room instance that this data corresponds to
		- level_name: The name of the level, displayed on the level select screen
		- level_portrait: The portait on the level select screen used to represent this level
		- card_color: An array of floats from 0-1 that corresponds to the color the level's card should be. The first value is the percentage of red red, the second value is of green, and the third is of blue.
	The rest correspond to Data Variables
	
	Data Variables:
	round_data: A 2D array containing all of the enemies (2nd dimension) that spawn in a round (1st dimension)
	defense_health: The amount of health the structure(s) you are defending has.
	
	TODO: Include purchasing data and starting money here? Or will these defined in some sort of player structure if the player is allowed to determine those?
*/
function LevelData(_basic_level_data = {
						level_room: undefined,
						level_name: "Default Name",
						level_portrait: spr_level_portrait_PortraitNotFound,
						card_color: [255/255, 255/255, 255/255]
					}, 
					_round_data = []) constructor {
	level_room = _basic_level_data.level_room;
	level_name = _basic_level_data.level_name;
	level_portrait = _basic_level_data.level_portrait;
	card_color = _basic_level_data.card_color;
	
	round_data = _round_data;
}
#endregion

#endregion