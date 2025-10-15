/*
This file contains data about the Plant Construct and its upgrades
*/
global.ANIMBANK_PLANT = new UnitAnimationBank(spr_plant_construct)

global.ANIMBANK_PLANT_U1 = new UnitAnimationBank(spr_plant_construct_u1);


#region PlantConstruct (Class)
function PlantConstruct() : CombatantData() constructor {
	name = "Plant"
	
	//Stats
	max_health = 100;
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 5; //Health points per second
	frames_per_restoration = seconds_to_roomspeed_frames(5);
	healing_amount = 10;
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(2));
	global_range = new GlobalRange(inst);
	
	projectile_data = {
				healing_amount: 10, 
				travel_speed: 5
			};
	num_projectiles = 2;
}
#endregion


#region Plant Construct Stat Upgrades
#endregion


#region Plant Construct Unit Upgrades
function UpgradePlantConstruct1(_unit = other) :
	UnitUpgrade("Flower Power", 100, 0, 0, 0) constructor {
		new_animbank = global.ANIMBANK_PLANT_U1;
		//new_stat_upgrade = new DirtConstructU1PierceUpgrade(_unit);
		
		static upgrade_fn = function() {
			with(unit_to_upgrade) {
				//Used to signify which upgrade was purchased. Maybe make this nicer.
				upgrade_purchased = 1;
				targeting_tracker = 
					new TargetingTracker([
									global.TARGETING_HEALTHY,
									global.TARGETING_WEAK,
					]);
			}
		}
}
#endregion