/// @description Create game state, round data, money data, and wall data

//Set current game state. Defaults to RUNNING
//game_state = GAME_STATE.RUNNING;
game_state_manager = new GameStateManager();


//Viewport variables used to calculate where things should go on the screen
//view_w = camera_get_view_width(view_camera[0]);
//view_h = camera_get_view_height(view_camera[0]);

//Camera Controller
camera_controller = new CameraController();

//Music Manager
music_manager = new MusicManager(Music_PreRound);

//Spawn Location and Path
level_path = new LevelPath(TILE_SIZE*-1, TILE_SIZE*5, pth_spawn1_SampleLevel1);

//Round Data
round_data = [
	[new EnemySpawningData([sample_enemy], [level_path], ENEMY_SPAWN_END, 10, 5)],
	[new EnemySpawningData([sample_enemy], [level_path], ENEMY_SPAWN_END, 10, 5)],
	[new EnemySpawningData([sample_enemy], [level_path], ENEMY_SPAWN_END, 10, 5)]
]

round_manager = new RoundManager(self.id, 3, round_data);

//Money Data (make this more sophisticated)
global.player_money = 200;

//Wall Data (make this more sophisticated)
global.wall_health = 200;

purchase_data = [new PurchaseData(sample_gunner, 100), new PurchaseData(sample_brawler, 100), new PurchaseData(sample_mortar, 200)]


//GUI Data
#region
game_ui = new GameUI(game_state_manager, round_manager, purchase_data);
game_ui.set_gui_running(); //Initialize GUI to running mode
#endregion

//Which unit the user has selected (make this more sophisticated)
purchase_selected = undefined;


/*
	Game Functions
*/
//TODO: Define them down here