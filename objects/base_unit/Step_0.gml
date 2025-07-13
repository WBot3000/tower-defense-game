/// @description Run unit actions

entity_data.animation_controller.on_step();

switch (entity_data.health_state) {
    case HEALTH_STATE.ACTIVE:
		entity_data.while_active();
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		entity_data.while_knocked_out();
		break;
    default:
        break;
}
