"""
Player State has a PlayerController and a PlayerSkin
"""
extends State
class_name PlayerState

var player: PlayerController
var skin: PlayerSkin

func _ready() -> void:
	yield(owner,"ready")
	player = owner
	skin = player.skin
