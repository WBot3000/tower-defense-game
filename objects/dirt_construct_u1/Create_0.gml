/// @description Initialize variables for the Dirt Construct
//TODO: For upgrades like these, should I make a "parent" construct that both the base and upgrade forms inherit?

//event_inherited(); //TODO: Use event inheritance?

unit_name = "Root'n Shoot'n Dirt Construct";

//Variables for managing unit health
if(!variable_instance_exists(self.id, "max_health")) { 
	max_health = 100;
}
if(!variable_instance_exists(self.id, "current_health")) { 
	current_health = 100;
}
if(!variable_instance_exists(self.id, "health_state")) { 
	health_state = UNIT_STATE.ACTIVE;
}
if(!variable_instance_exists(self.id, "recovery_rate")) { 
	recovery_rate = 10; //In health points per second
}
if(!variable_instance_exists(self.id, "defense_factor")) { 
	defense_factor = 1;
}

if(!variable_instance_exists(self.id, "direction_facing")) { 
	direction_facing = DIRECTION_LEFT;
}

//Variables for managing unit's attack
if(!variable_instance_exists(self.id, "range")) { 
	range = new CircularRange(self.id, get_bbox_center_x(self), get_bbox_center_y(self), tilesize_to_pixels(3));
}
if(!variable_instance_exists(self.id, "enemies_in_range")) { 
	enemies_in_range = ds_list_create();
}
if(!variable_instance_exists(self.id, "targeting_tracker")) { 
	targeting_tracker = 
		new TargetingTracker([
						global.TARGETING_CLOSE,
						global.TARGETING_FIRST,
						global.TARGETING_LAST,
						global.TARGETING_HEALTHY,
						global.TARGETING_WEAK,
		]);
}

if(!variable_instance_exists(self.id, "frames_per_shot")) { 
	frames_per_shot = seconds_to_roomspeed_frames(2);
}
if(!variable_instance_exists(self.id, "shot_timer")) { 
	shot_timer = 0;
}
if(!variable_instance_exists(self.id, "shot_damage")) { 
	shot_damage = 10;
}
if(!variable_instance_exists(self.id, "shot_speed")) { 
	shot_speed = 15;
}
shot_pierce = 3; //Number of enemies the shot can pierce before getting destroyed

if(!variable_instance_exists(self.id, "unit_buffs")) { 
	unit_buffs = [];
}

//Stat Upgrades (TODO: Currently bugged, probably need to update some UI code too)
if(!variable_instance_exists(self.id, "stat_upgrades")) { 
	stat_upgrades = [new DirtConstructDamageUpgrade(self.id), new DirtConstructAttackSpeedUpgrade(self.id), 
		new DirtConstructRestorationUpgrade(self.id), undefined];
}
//TODO: Define the fourth stat upgrade here

//Unit Upgrades
unit_upgrade_1 = undefined;
unit_upgrade_2 = undefined;
unit_upgrade_3 = undefined;

if(!variable_instance_exists(self.id, "sell_price")) { 
	sell_price = global.DATA_PURCHASE_DIRT.price * SELL_PRICE_REDUCTION;
}

//TODO: Animation controller?