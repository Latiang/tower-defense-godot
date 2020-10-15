extends Area2D

export (PackedScene) var Bullet


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	pass

func fire():
	var dir = Vector2(cos($AnimatedSprite.rotation + PI/2), sin($AnimatedSprite.rotation + PI/2))
	$Gun.spawn_bullet(position, dir)

func rotate(angle):
	$AnimatedSprite.rotation = angle

func _on_ProgrammableBehaviour_fire():
	fire()
	$ProgrammableBehaviour.lock_for_time(1)

func _on_ProgrammableBehaviour_rotate(angle):
	rotate(angle)
