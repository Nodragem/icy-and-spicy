extends PlayerState

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim"):
		_state_machine.transition_to("Aim")

func enter(msg: = {}) -> void:
	model.play_aiming(false)
