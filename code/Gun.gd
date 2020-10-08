extends Node

export (PackedScene) var Bullet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_bullet(position, direction):
	var bullet = Bullet.instance()
	bullet.position = position
	bullet.rotation = direction.angle()
	bullet.z_index = 10
	bullet.velocity = -direction*bullet.bullet_speed
	add_child(bullet)
