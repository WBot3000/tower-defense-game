/*
This file contains data about the Flame Construct and its upgrades
*/
global.ANIMBANK_FLAME = new UnitAnimationBank(spr_flame_construct)
//global.ANIMBANK_FLAME.add_animation("SHOOT", spr_flame_construct_shooting);

global.ANIMBANK_FLAME_U1 = new UnitAnimationBank(spr_flame_construct_u1_1);
//global.ANIMBANK_FLAME_U1.add_animation("SHOOT", spr_flame_construct_shooting_u1_1);

#region FlameConstruct (Class)
function FlameConstruct() : CombatantData() constructor {
	name = "Flame"
	
	//Stats
	max_health = 100;
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	damage = 1;
	frames_per_damage = 5;
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));
}
#endregion


#region FlameConstructFlamethrower (Class)
function FlameConstructFlamethrower(_owner) constructor {
	owner = _owner;
	
	damage_timer = owner.entity_data.frames_per_damage - 2;
	target = noone;
	particle_effect = new ParticleBeam(spr_flame, owner, noone, 1, BEAM_SPEED_DEFAULT, tilesize_to_pixels(0.5));
	
	static set_target = function(_new_target) {
		target = _new_target;
		particle_effect.end_instance = _new_target;
	}
	
}
#endregion


#region Flame Construct Stat Upgrades
#endregion


#region Flame Construct Unit Upgrades
/*
	Upgrade from Flame Construct to Heat-dra
*/
function UpgradeFlameConstruct1(_unit = other) :
	UnitUpgrade("Heat-dra", 100, 0, 0, 0) constructor {
		new_animbank = global.ANIMBANK_FLAME_U1;
		//new_stat_upgrade = new DirtConstructU1PierceUpgrade(_unit);
		
		static upgrade_fn = function() {
			array_push(unit_to_upgrade.flamethrowers, new FlameConstructFlamethrower(unit_to_upgrade));
		}
}
#endregion