extends PlayerState

export var max_speed: = 6.0
export var acceleration:= 50
export var gravity: = -30.0
export var snap_length := 0.5
export var do_stop_on_slope := true
export var has_infinite_inertia := true

var velocity := Vector3.ZERO
var _move_direction := Vector3.ZERO
var _snap := Vector3.DOWN * snap_length


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.is_on_floor():
		_state_machine.transition_to("Move/Jump", {velocity = velocity})


func physics_process(delta: float) -> void:
	_move_direction = _get_player_input()
	
	_update_velocity(_move_direction, delta)
	velocity = player.move_and_slide_with_snap(
		velocity,        _snap,  Vector3.UP, 
		do_stop_on_slope,    4, deg2rad(45), 
		has_infinite_inertia
	
	)
	
	model.update_animation(_move_direction, velocity.length() / max_speed, delta)


func _get_player_input() -> Vector3:
	var input = Vector3(
		Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_down") - 
		Input.get_action_strength("move_up")
	)

	input = camera.global_transform.basis.xform(input)
	input.y = 0
	input = input.normalized()
	
	return input

func _update_velocity(move_direction: Vector3, delta: float):
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.linear_interpolate(_move_direction * max_speed, acceleration * delta)
	
	velocity.y = y_velocity + gravity * delta # preserve y


