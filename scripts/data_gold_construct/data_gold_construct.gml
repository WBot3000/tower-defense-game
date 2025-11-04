/*
This file contains data about the Gold Construct and its upgrades
*/
global.ANIMBANK_GOLD = new UnitAnimationBank(spr_gold_construct)
global.ANIMBANK_GOLD.add_animation("GENERATE", spr_gold_construct_generate);

global.ANIMBANK_GOLD_U1 = new UnitAnimationBank(spr_gold_construct_u1)
global.ANIMBANK_GOLD_U1.add_animation("GENERATE", spr_gold_construct_u1_generate);

#region GoldConstruct (Class)
function GoldConstruct() : CombatantData() constructor {
	name = "Gold"
	
	//Health variables
	max_health = 100;
	
	//Stat modifiers
	defense_factor = 0.75; //All taken damage is divided by this value
	recovery_rate = 5; //Health points per second
	frames_per_generation = seconds_to_roomspeed_frames(8);
	money_generation_amount = 50;
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));
}
#endregion


#region Gold Construct Stat Upgrades

#endregion


#region Gold Construct Unit Upgrades
function UpgradeGoldConstruct1(_unit = other) :
	UnitUpgrade("Gold Rush", 100, 0, 0, 0) constructor {
		new_animbank = global.ANIMBANK_GOLD_U1;
		//new_stat_upgrade = new DirtConstructU1PierceUpgrade(_unit);
		
		static upgrade_fn = function() {
			with(unit_to_upgrade) {
				//Used to signify which upgrade was purchased. Maybe make this nicer.
				upgrade_purchased = 1;
				//Give all surrounding units the buff
				entity_data.sight_range.get_entities_in_range([base_unit], entities_in_range);
				for(var i = 0, len = ds_list_size(entities_in_range); i < len; ++i) {
					var _unit = entities_in_range[| i];
					_unit.buffs.apply_buff(/*new GoldRushBuff(_unit)*/BUFF_IDS.GOLD_RUSH, [self]);
				}
				show_debug_message("Should have buffed " + string(ds_list_size(entities_in_range)) + " units.");
				ds_list_clear(entities_in_range);
				//Need to buff newly purchased units near us
				add_broadcast_subscriber(get_logic_controller(), EVENT_UNIT_PURCHASED, function(args) {
					var _unit = args[0]; //args[0] = unit purchased
					if(entity_data.sight_range.is_entity_in_range(_unit)) {
						_unit.buffs.apply_buff(BUFF_IDS.GOLD_RUSH, [self]);
					}
				});
			}
		}
}
#endregion