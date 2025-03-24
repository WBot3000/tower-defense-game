/*
This file contains the PurchaseManager, responsible for showing and handling which unit is selected for purchase
*/
#region PurchaseManager (Class)
/*
	TODO: Description
	
	Argument Variables:
	
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