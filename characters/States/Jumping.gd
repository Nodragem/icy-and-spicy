extends PlayerState

export var jump_initial_impulse := 12.0
export var jump_additional_force := 4.5

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if player._velocity.y <= 0:
		_state_machine.transition_to("Move/Falling")

func enter(msg: = {}) -> void:
	_parent.velocity.y = jump_initial_impulse
	_parent._snap = Vector3.ZERO
	skin.transition_to(skin.States.JUMPING)
	_parent.enter(msg)


func exit() -> void:
	_parent.exit()
