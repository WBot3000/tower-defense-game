/*
	data_purchase.gml
	
	This file contains structs containing purchasing data for all of your units.
*/

#region Data Constructors

#region PurchaseData (Class)
/*
	Contains the data necessary for making a unit purchase. Mainly just a data container.
	unit: The unit object that will be placed upon the making of a purchase
	price: The amount the unit costs
	button_sprite: The sprite that you can draw around 
	
	TODO: If I decide to create a "unit_data" struct, replace the entity object reference with the unit_data struct
*/
function PurchaseData(_unit, _price, _button_sprite = object_get_sprite(_unit)) constructor {
	unit = _unit;
	price = _price;
	button_sprite = _button_sprite;
}
#endregion

#endregion

#region Data Definitions

#region Purchase Data
global.DATA_PURCHASE_SAMPLE_GUNNER = new PurchaseData(sample_gunner, 100);
global.DATA_PURCHASE_SAMPLE_BRAWLER = new PurchaseData(sample_brawler, 150);
global.DATA_PURCHASE_SAMPLE_MORTAR = new PurchaseData(sample_mortar, 200);

global.DATA_PURCHASE_DIRT = new PurchaseData(dirt_construct, 100);
global.DATA_PURCHASE_COBBLESTONE = new PurchaseData(cobblestone_construct, 150);
global.DATA_PURCHASE_GOLD = new PurchaseData(gold_construct, 300);
global.DATA_PURCHASE_CLOUD = new PurchaseData(cloud_construct, 300);
#endregion

#endregion