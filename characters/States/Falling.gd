extends PlayerState

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if player.is_on_floor() and _parent._snap == Vector3.ZERO:
		_state_machine.transition_to("Move/Idle")

func enter(msg: = {}) -> void:
	skin.transition_to(skin.States.FALLING)
	_parent.enter(msg)


func exit() -> void:
	_parent.exit()
