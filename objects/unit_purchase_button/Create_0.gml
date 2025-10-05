/// @description Initialize variables
event_inherited();
highlighted = false;
enabled = false;

purchase_manager = get_purchase_manager(); //Cache this for easy access
if(purchase_manager != undefined) {
	enabled = true;
}