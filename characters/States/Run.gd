extends PlayerState


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if not player.is_on_floor(): 
		_state_machine.transition_to("Move/Falling")


func enter(msg: = {}) -> void:
	skin.transition_to(skin.States.RUN)
	_parent.enter(msg)


func exit() -> void:
	_parent.exit()
