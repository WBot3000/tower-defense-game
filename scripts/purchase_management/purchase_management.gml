/*
This file contains the PurchaseManager, responsible for showing and handling which unit is selected for purchase
*/

#region can_purchase_unit (Function)
//Used for determining if a unit can be placed on a certain tile
function can_purchase_unit(_tile, _purchase_data) {
	//Make sure tile can accept any units, and the unit is on the tile's approved list if it has one.
	return _tile.placeable && _tile.placed_unit == noone && 
		global.player_money >= _purchase_data.price && 
		(array_length(_tile.valid_units) == 0 || array_contains(_tile.valid_units, _purchase_data.unit));
}
#endregion


#region PurchaseManager (Class)
/*
	Manager that keeps track of the currently selected purchasing data.
	
	Argument Variables:
	No argument variables
	
	Data Variables:
	currently_selected_purchase: The purchase data needed to register a purchase
*/
function PurchaseManager() constructor {
	currently_selected_purchase = undefined;
	
	static set_selected_purchase = function(_purchase_data) {
		currently_selected_purchase = _purchase_data;
	}
	
	static deselect_purchase = function() {
		currently_selected_purchase = undefined;
	}
	
}
#endregion