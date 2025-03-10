/// @description Initialize variables and data structures

name = "Sample Gunner U1";

//Quick work-around to check if
if(!variable_instance_exists(self.id, "max_health")) { 
	max_health = 100;
}


if(!variable_instance_exists(self.id, "current_health")) { 
	max_health = 100;
}

if(!variable_instance_exists(self.id, "health_state")) { 
	health_state = UNIT_STATE.ACTIVE;
}

if(!variable_instance_exists(self.id, "recovery_rate")) { 
	recovery_rate = 10; //In health points per second
}

if(!variable_instance_exists(self.id, "radius")) { 
	radius = 2.5; //TODO: Maybe make name clearer
}

if(!variable_instance_exists(self.id, "range")) { 
	range = new CircularRange(id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(radius));
}

if(!variable_instance_exists(self.id, "shooting_speed")) { 
	shooting_speed = 8;
}

if(!variable_instance_exists(self.id, "seconds_per_shot")) { 
	seconds_per_shot = 2;
}

if(!variable_instance_exists(self.id, "bullet_damage")) { 
	bullet_damage = 10;
}

if(!variable_instance_exists(self.id, "unit_buffs")) { 
	unit_buffs = [];
}

//Upgradable Stats
if(!variable_instance_exists(self.id, "stat_upgrade_1")) { 
	stat_upgrade_1 = new SampleGunnerAttackSpeedUpgrade(self.id);
}
if(!variable_instance_exists(self.id, "stat_upgrade_2")) { 
	stat_upgrade_2 = new SampleGunnerDamageUpgrade(self.id);
}
if(!variable_instance_exists(self.id, "stat_upgrade_3")) { 
	stat_upgrade_3 = new SampleGunnerRangeUpgrade(self.id);
}
//TODO: Add Stat Upgrade 4

//Shouldn't have any unit upgrades after the initial
delete unit_upgrade_1;
delete unit_upgrade_2;
delete unit_upgrade_3;


if(!variable_instance_exists(self.id, "enemies_in_range")) { 
	//Variables to keep track of and control things
	enemies_in_range = ds_list_create();
}

if(!variable_instance_exists(self.id, "shot_timer")) { 
	shot_timer = 90; //When the unit is placed, takes less time to take a shot.
}

if(!variable_instance_exists(self.id, "animation_controller")) { 
	animation_controller = new AnimationController(self.id, spr_sample_gunner_upgrade_1);
}




