/// @description Give money to player equal to the enemy's cash value
global.player_money += monetary_value
if(variable_instance_exists(self.id, "destroy_callback")) {
	destroy_callback(self.id);
}