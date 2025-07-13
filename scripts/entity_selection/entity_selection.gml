/*
This file contains code related to selecting entities (currently units, might add support for enemies down the line)
*/

//TODO: Merge with PurchaseManager into a single "SelectionManager"?
#region SelectedEntityManager (Class)
/*
	Manager that keeps track of the entity the player has currently selected.
	
	Argument Variables:
	No argument variables
	
	Data Variables:
	currently_selected_entity: The purchase data needed to register a purchase
*/
function SelectedEntityManager() constructor {
	currently_selected_entity = noone;
	
	static set_selected_entity = function(_entity) {
		currently_selected_entity = _entity;
	}
	
	static deselect_entity = function() {
		currently_selected_entity = noone;
	}
	
}
#endregion