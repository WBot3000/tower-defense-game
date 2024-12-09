/// @description Create game state, round data, money data, and wall data

//Set current game state. Defaults to RUNNING
game_state = GAME_STATE.RUNNING;

//Surface drawn when the game is paused
pause_screen_surface = -1;


//Viewport variables used to calculate where things should go on the screen
//view_w = camera_get_view_width(view_camera[0]);
//view_h = camera_get_view_height(view_camera[0]);

//Camera Controller
camera_controller = new CameraController();

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
global.player_money = 100;

//Wall Data (make this more sophisticated)
global.wall_health = 200;

//Menu-Specific
pause_menu = new PauseMenu((1/2), (1/2));

purchase_menu_state = PURCHASE_MENU_STATE.CLOSED; //Whether the menu on the side is opened or closed
//NOTE: Might make separate states for the different side menus

purchase_menu = new UnitPurchaseMenu((1/3), window_get_height(), 
	[new PurchaseData(sample_gunner, 100), new PurchaseData(sample_brawler, 100), new PurchaseData(sample_mortar, 200)]);
/*
purchase_menu = instance_create_layer(0, 0, MENU_LAYER, unit_purchase_menu,
	{
		button_purchase_data: [PURCHASE_SAMPLE_GUNNER, PURCHASE_SAMPLE_BRAWLER, PURCHASE_SAMPLE_MORTAR]
	});
*/

//Which unit the user has selected (make this more sophisticated)
//unit_picked = sample_gunner; //Old version
purchase_selected = undefined;