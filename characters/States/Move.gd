extends PlayerState

export var max_speed: = 15.0
export var acceleration:= 50
export var gravity: = -30.0
export var snap_length := 0.5
export var do_stop_on_slope := true
export var has_infinite_inertia := true

var velocity := Vector3.ZERO
var _move_direction := Vector3.ZERO
var _snap := Vector3.DOWN * snap_length

var _player_input := Vector3.ZERO
var _input_origin := Transform2D.IDENTITY #TODO


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.is_on_floor():
		_state_machine.transition_to("Move/Jump", {velocity = velocity})


func physics_process(delta: float) -> void:
	_update_player_input()
	
	_move_direction.x = _player_input.x
	_move_direction.z = _player_input.z
	
	_update_velocity(_move_direction, delta)
	velocity = player.move_and_slide_with_snap(
		velocity,        _snap,  Vector3.UP, 
		do_stop_on_slope,    4, deg2rad(45), 
		has_infinite_inertia
	
	)
	
	model.update_animation(_move_direction, velocity.length() / max_speed, delta)


func _update_player_input():
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_player_input = Vector3(input.x, 0, input.y)
	
	_player_input = camera.global_transform.basis.xform(_player_input)
	_player_input.y = 0
	_player_input = _player_input.normalized()


func _update_velocity(move_direction: Vector3, delta: float):
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.linear_interpolate(_move_direction * max_speed, acceleration * delta)
	
	velocity.y = y_velocity + gravity * delta # preserve y


