extends RigidBody
class_name Arrow

signal exploded

export var initial_velocity = 25
export var dgravity = Vector3.DOWN * 20

var velocity = Vector3.ZERO


func _physics_process(delta):
	if velocity.length_squared() > 0.01:
		look_at(transform.origin + velocity.normalized(), Vector3.UP)
	

func _on_Shell_body_entered(body):
	emit_signal("exploded", transform.origin)
	queue_free()
