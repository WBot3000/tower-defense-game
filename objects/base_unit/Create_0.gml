/// @description Initialize data structures

name = "NAME_NOT_PROVIDED";

max_health = 0;
current_health = 0;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 0; //In health points per second

radius = 0.0;

unit_buffs = [];

//Variables to keep track of things
enemies_in_range = ds_list_create();


