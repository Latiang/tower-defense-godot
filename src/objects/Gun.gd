extends Node

export (PackedScene) var Bullet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_bullet(position, direction, speed_multiplier=1):
	var bullet = Bullet.instance()
	bullet.position = position
	bullet.rotation = direction.angle()
	bullet.z_index = 10
	bullet.velocity = -direction*bullet.speed*speed_multiplier
	add_child(bullet)
	
func update_bullet_speeds(speed_multiplier):
	for child in self.get_children():
		child.velocity = child.velocity.normalized() * speed_multiplier * child.speed
