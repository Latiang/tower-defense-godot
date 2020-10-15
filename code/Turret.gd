extends Area2D

export (PackedScene) var Bullet


# Called when the node enters the scene tree for the first time.
func _ready():
	$SensorCast.enabled = true
	
# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	pass

func fire():
	var dir = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
	$Gun.spawn_bullet(position, dir)

func rotate(angle):
	rotation = angle

func sensor_detect(out_dict):
	var dir = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
	out_dict[0] = $SensorCast.is_colliding()

func _on_ProgrammableBehaviour_fire():
	fire()
	$ProgrammableBehaviour.lock_for_time(0.3)

func _on_ProgrammableBehaviour_rotate(angle):
	rotate(angle)

func _on_ProgrammableBehaviour_sensor_detect(out_dict):
	sensor_detect(out_dict)
