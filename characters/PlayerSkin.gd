class_name PlayerSkin
extends Spatial

signal attack_finished

export var auto_fall := true
const MOVE_SPEED_THRESHOLD := 0.6
const IDLE_BREAK_WAIT_TIME := 7.0

var velocity := Vector3.ZERO setget set_velocity

var _is_idle := false setget _set_is_idle
var _idle_break_timer := Timer.new()

onready var anim_player: AnimationPlayer = $AnimationPlayer

onready var _tree: AnimationTree = $AnimationTree
onready var _playback: AnimationNodeStateMachinePlayback = _tree["parameters/playback"]


func _ready() -> void:
	_tree.active = true
	add_child(_idle_break_timer)
	_idle_break_timer.wait_time = IDLE_BREAK_WAIT_TIME
	_idle_break_timer.one_shot = true
	_idle_break_timer.connect("timeout", _playback, "travel", ["Idle-break"])
	anim_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


func _physics_process(delta: float) -> void:

	var speed_squared := velocity.length_squared()

	var is_moving := speed_squared >= MOVE_SPEED_THRESHOLD
	_set_is_idle(speed_squared <= MOVE_SPEED_THRESHOLD)
	_tree["parameters/conditions/is_moving"] = is_moving
	_tree["parameters/conditions/is_idle"] = _is_idle
	_tree["parameters/conditions/is_moving_or_idling"] = _is_idle or is_moving
	var fall_list = ["Run-loop", "Jumping"] if auto_fall else ["Jumping"]
	if velocity.y < 0.0 and _playback.get_current_node() in fall_list:
		_playback.travel("Falling")
	elif _playback.get_current_node() == "Falling" and is_equal_approx(velocity.y, 0.0):
		_playback.travel("Idle-loop")  
	
		# NOTE: Idle-loop switches immediately to Run-loop if is_moving==true
		# TODO: try to replace with is_falling:
#		_tree["parameters/conditions/is_falling"] = velocity.y < 0.0
#		_tree["parameters/conditions/not_falling"] = is_equal_approx(velocity.y, 0.0)


func set_velocity(new_velocity: Vector3) -> void:
	velocity = new_velocity


func jump() -> void:
	_playback.travel("Jumping")


func land() -> void:
	if velocity.length_squared() > 0.0:
		_playback.travel("Idle-loop")  
	else: 
		_playback.travel("Run-loop")


func attack() -> void:
#	_playback.travel("attack")
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("attack_finished")


func is_attacking() -> bool:
	return _playback.get_current_node() == "attack"


func is_falling() -> bool:
	return _playback.get_current_node() == "Falling"


func _set_is_idle(new_value: bool) -> void:
	if new_value and not _is_idle:
		_idle_break_timer.start(IDLE_BREAK_WAIT_TIME)
	elif not new_value:
		_idle_break_timer.stop()
	_is_idle = new_value


func _on_idle_break_end() -> void:
	# We restart the idle break timer if the break ends. Leaving the idle state will stop the timer.
	_idle_break_timer.stop()
	_idle_break_timer.start(IDLE_BREAK_WAIT_TIME)
