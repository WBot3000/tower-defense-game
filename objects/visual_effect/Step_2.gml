/// @description Update graphic position in case the entity moves
if(instance_exists(entity_to_follow)) {
	x += (entity_to_follow.x - entity_to_follow.xprevious)
	y += (entity_to_follow.y - entity_to_follow.yprevious)
}