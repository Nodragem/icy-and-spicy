extends PlayerState


export var max_speed: = 50.0
export var move_speed: = 500.0
export var gravity: = -80.0
export var rotation_speed := 12.0
export var snap_length := 0.5
export var do_stop_on_slope := true
export var has_infinite_inertia := true

var _velocity := Vector3.ZERO
var _move_direction := Vector3.ZERO
var _last_strong_direction := Vector3.FORWARD
var _snap := Vector3.DOWN * snap_length

onready var _camera_controller := $ThirdPersonCamera
onready var _model := $IcySkin

onready var _start_position := player.global_transform.origin

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.is_on_floor():
		_state_machine.transition_to("Move/Jumping", {_velocity = _velocity})


func physics_process(delta: float) -> void:
	_move_direction = _get_player_input()
	
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction

	_orient_model_to_direction(_last_strong_direction, delta)
	_update_velocity(_move_direction, delta)
	_velocity = player.move_and_slide_with_snap(
		_velocity,       _snap,  Vector3.UP, 
		do_stop_on_slope,    4, deg2rad(45), 
		has_infinite_inertia
	
	)


func _get_player_input() -> Vector3:
	var input = Vector3(
		Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_back") - 
		Input.get_action_strength("move_front")
	)

	if input.length() > 1.0:
		input = input.normalized()
	
	input = _camera_controller.global_transform.basis.xform(input)
	
	return input


func _update_velocity(move_direction: Vector3, delta: float):
	var y_velocity := _velocity.y
	_velocity = move_direction * delta * move_speed
	if _velocity.length() > max_speed:
		_velocity = _velocity.normalized() * max_speed
	
	_velocity.y = y_velocity # preserve y


func _orient_model_to_direction(direction: Vector3, delta: float) -> void:
	# METHOD 1:
	# skin.look_at(player.global_transform.origin +\
	# _move_direction, Vector3.UP)
	
	# METHOD 2:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction)\
	.orthonormalized()
	
	## in what sense is it different from transform.look_at + interpolate_with?
	skin.transform.basis = skin.transform.basis\
	.orthonormalized()\
	.slerp(rotation_basis, delta * rotation_speed)\
	.scaled(skin.scale)
	
	# can also try this:
	#	_model.transform.basis = _model.transform.basis
	#	.get_rotation_quat().slerp(
	#		rotation_basis, delta * rotation_speed
	#	)