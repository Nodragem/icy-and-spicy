class_name PlayerSkin
extends Spatial

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var anim_tree: AnimationTree = $AnimationTree
onready var shoot_anchor: Position3D = $ShootAnchor
export var rotation_speed := 12.0

var _last_strong_direction := Vector3.FORWARD

func _ready() -> void:
	anim_tree.active = true

func update_animation(move_direction, velocity_ratio, delta) -> void:
	if move_direction.length() > 0.2:
		_last_strong_direction = move_direction

	_orient_model_to_direction(_last_strong_direction, delta)
	anim_tree["parameters/blend_running/blend_amount"] = velocity_ratio
	anim_tree["parameters/blend_straffing/blend_amount"] = velocity_ratio
	

func move_to_falling() -> void:
	anim_tree["parameters/state/current"] = 3


func move_to_jumping() -> void:
	anim_tree["parameters/state/current"] = 2


func move_to_running() -> void:
	anim_tree["parameters/state/current"] = 0


func play_idle_break(value: bool) -> void:
	anim_tree["parameters/on_idle_break/active"] = value
	

func play_aiming(value: bool) -> void:
	if value:
		anim_tree["parameters/blend_aim/blend_amount"] = 1
	else:
		anim_tree["parameters/blend_aim/blend_amount"] = 0


func _orient_model_to_direction(direction: Vector3, delta: float) -> void:
	# METHOD 1:
	# model.look_at(player.global_transform.origin +\
	# _move_direction, Vector3.UP)
	
	# METHOD 2:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction)\
	.orthonormalized()
	
	## in what sense is it different from transform.look_at + interpolate_with?
	self.transform.basis = self.transform.basis\
	.orthonormalized()\
	.slerp(rotation_basis, delta * rotation_speed)\
	.scaled(self.scale)
	
	# can also try this:
	#	_model.transform.basis = _model.transform.basis
	#	.get_rotation_quat().slerp(
	#		rotation_basis, delta * rotation_speed
	#	)
