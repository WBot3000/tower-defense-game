/// @description Give money to player equal to the enemy's cash value
global.player_money += monetary_value
if(variable_instance_exists(self.id, "destroy_callback")) { //IIRC this is for Round Management
	destroy_callback(self.id);
}