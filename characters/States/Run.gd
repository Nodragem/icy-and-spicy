extends PlayerState


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if player.is_on_floor() or player.is_on_wall():
		if _parent.velocity.length() < 0.01:
			_state_machine.transition_to("Move/Idle")
	# else:
	# 	_state_machine.transition_to("Move/Jump")
	# if not player.is_on_floor(): 
	# 	_state_machine.transition_to("Move/Falling")


func enter(msg: = {}) -> void:
	_parent.enter(msg)


func exit() -> void:
	_parent.exit()
