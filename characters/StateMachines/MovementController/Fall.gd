extends PlayerState

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if player.is_on_floor() and _parent._snap == Vector3.ZERO:
		_state_machine.transition_to("Move/Idle")

func enter(msg: = {}) -> void:
	model.move_to_falling()
	_parent.enter(msg)


func exit() -> void:
	_parent.exit()
