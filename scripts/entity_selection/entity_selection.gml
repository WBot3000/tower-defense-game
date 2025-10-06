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
		//Update UI elements appropriately
		selected_entity_picture.entity = _entity;
		with(stat_upgrade) {
			entity = _entity;
		}
		with(unit_upgrade_purchase_button) {
			entity = _entity;
		}
		targeting_selector.entity = _entity;
		targeting_selector_left_arrow.entity = _entity;
		targeting_selector_right_arrow.entity = _entity;
		sell_button.entity = _entity;
	}
	
	static deselect_entity = function() {
		set_selected_entity(noone);
	}
	
}
#endregion