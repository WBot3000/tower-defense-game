/*
This file contains all of the data for levels taking place in Daniel's Potato Farm
*/
#region Data Definitions

#region Path Data
global.DATA_LEVEL_PATH_DUMMYPATH = new PathData(0, 0, pth_dummypath); //This path isn't level-specific, so it can stay global (note: can probably get rid of this with how paths + movement works now)

global.DATA_LEVEL_PATH_SAMPLELEVEL1_1 = new PathData(TILE_SIZE*-1, TILE_SIZE*8, pth_spawn1_SampleLevel1);

global.DATA_LEVEL_PATH_SAMPLELEVEL2_1 = new PathData(TILE_SIZE*-1, TILE_SIZE*6, pth_spawn1_SampleLevel2);
global.DATA_LEVEL_PATH_SAMPLELEVEL2_2 = new PathData(TILE_SIZE*-1, TILE_SIZE*7, pth_spawn2_SampleLevel2);

global.DATA_LEVEL_PATH_SAMPLELEVEL3_1 = new PathData(TILE_SIZE*-1, TILE_SIZE*20, pth_spawn1_SampleLevel3);
global.DATA_LEVEL_PATH_SAMPLELEVEL3_2 = new PathData(TILE_SIZE*-1, TILE_SIZE*20, pth_spawn2_SampleLevel3);
global.DATA_LEVEL_PATH_SAMPLELEVEL3_3 = new PathData(TILE_SIZE*-1, TILE_SIZE*20, pth_spawn3_SampleLevel3);
#endregion

#macro WORLD_1_CARD_COLOR [148/255, 224/255, 168/255]

#region Level Data
//TODO: Round data is ok to read for these sample levels, but I can tell it's gonna be a pain to read with actual levels. Think of the best way to manage this


//Rename to DATA_LEVEL_WORLD1_LEVEL1
global.DATA_LEVEL_MAIN_SAMPLELEVEL1 = new LevelData(
	{
		level_room: SampleLevel1,
		level_name: "Dan's Potato Farm 1",
		level_portrait: spr_level_portrait_SampleLevel1,
		card_color: WORLD_1_CARD_COLOR,
	},
	[
		[
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], 5, 4, 5),
			new EnemySpawningData([sword_beetle], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], 5, 1, 5),
			new EnemySpawningData([butterflybarian], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], 5, 4, 5),
			new EnemySpawningData([sword_beetle], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], ENEMY_SPAWN_END, 1, 5),
		],
		[
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], 5, 3, 1),
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], 5, 3, 1),
			new EnemySpawningData([sword_beetle], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], 5, 3, 1),
			new EnemySpawningData([gun_beetle], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], ENEMY_SPAWN_END, 3, 5),
		],
		[
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], 5, 1, 1),
			new EnemySpawningData([king_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL1_1], ENEMY_SPAWN_END, 0, 1)
		],
	]
);

global.DATA_LEVEL_MAIN_SAMPLELEVEL2 = new LevelData(
	{
		level_room: SampleLevel2,
		level_name: "Dan's Potato Farm 2",
		level_portrait: spr_level_portrait_SampleLevel1,
		card_color: WORLD_1_CARD_COLOR,
	},
	[
		[
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL2_1], ENEMY_SPAWN_END, 1, 5)
		],
		[
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL2_2], ENEMY_SPAWN_END, 1, 5)
		],
		[
			new EnemySpawningData([chompy_worm, chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL2_1, global.DATA_LEVEL_PATH_SAMPLELEVEL2_2], ENEMY_SPAWN_END, 1, 5)
		]
	]
);

global.DATA_LEVEL_MAIN_SAMPLELEVEL3 = new LevelData(
	{
		level_room: SampleLevel3,
		level_name: "Dan's Potato Farm 3",
		level_portrait: spr_level_portrait_SampleLevel1,
		card_color: WORLD_1_CARD_COLOR,
	},
	[
		[
			new EnemySpawningData([chompy_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL3_1], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([butterflybarian], [global.DATA_LEVEL_PATH_SAMPLELEVEL3_2], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([gun_beetle], [global.DATA_LEVEL_PATH_SAMPLELEVEL3_3], ENEMY_SPAWN_END, 10, 5)
		],
		[
			new EnemySpawningData([king_worm], [global.DATA_LEVEL_PATH_SAMPLELEVEL3_3], ENEMY_SPAWN_END, 0, 1)
		],
	]
);
#endregion

#endregion