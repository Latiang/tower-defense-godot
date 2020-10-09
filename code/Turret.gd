extends Area2D

export (PackedScene) var Bullet


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	$AnimatedSprite.rotation = position.angle_to_point(get_viewport().get_mouse_position()) - PI/2
	if Input.is_action_pressed("mouse_left_click"):
		fire((position-get_viewport().get_mouse_position()).normalized())

func fire(dir : Vector2):
	$Gun.spawn_bullet(position, dir)
