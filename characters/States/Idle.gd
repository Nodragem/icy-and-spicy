extends PlayerState

const IDLE_BREAK_WAIT_TIME := 1.0
var _break_timer := Timer.new()

func _ready() -> void:
	yield(owner, "ready")
	print("Idle Ready")
	add_child(_break_timer)
	_break_timer.wait_time = IDLE_BREAK_WAIT_TIME
	_break_timer.one_shot = false
	_break_timer.connect("timeout", model, "play_idle_break", [true])
	

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if player.is_on_floor() and _parent.velocity.length() > 0.01:
		_state_machine.transition_to("Move/Run")
	
	# elif not player.is_on_floor():
	# 	_state_machine.transition_to("Move/Air")

func enter(msg: = {}) -> void:
	_break_timer.start(IDLE_BREAK_WAIT_TIME)
	_parent.velocity = Vector3.ZERO
	_parent.enter(msg)


func exit() -> void:
	model.play_idle_break(false)
	_break_timer.stop()
	_parent.exit()
