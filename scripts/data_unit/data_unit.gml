/*
This file contains data for all the different types of units in the game.
Sometimes, we might need to refer to some stats that a unit has before initializing any instances of that unit.
This data can be used to refer to units in these instances.
This data is also used when the corresponding unit is created.
*/

//Used to determine whether a unit should perform its tasks, or whether it needs to recover first.
enum UNIT_STATE {
	ACTIVE,
	KNOCKED_OUT
}