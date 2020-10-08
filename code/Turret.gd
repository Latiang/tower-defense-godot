extends Area2D

export (PackedScene) var Bullet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.rotation = position.angle_to_point(get_viewport().get_mouse_position()) - PI/2
	if Input.is_action_pressed("mouse_left_click"):
		var bullet_dir = (position-get_viewport().get_mouse_position()).normalized()
		$Gun.spawn_bullet(position, bullet_dir)
