"""
Player State has a PlayerController and a PlayerSkin
"""
extends State
class_name PlayerState

var player: PlayerController
var model: PlayerSkin
var camera: Camera
var anim_tree: AnimationTree

func _ready() -> void:
	yield(owner,"ready")
	player = owner
	model = player.model
	camera = player.camera_controller
	anim_tree = player.anim_tree
