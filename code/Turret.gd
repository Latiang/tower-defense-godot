extends Area2D

export (PackedScene) var Bullet


export var can_rotate = true
export var integrated_sensor = true
export var can_move = false
export var reload_time = 0.3 #seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	pass

func fire():
	var dir = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
	$Gun.spawn_bullet(position, dir)

func rotate(angle):
	if (can_rotate):
		rotation = angle

func sensor_detect(out_dict):
	if (integrated_sensor):
		var dir = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
		out_dict[0] = $SensorCast.is_colliding()
	else:
		out_dict[0] = false

func _on_ProgrammableBehaviour_fire():
	fire()
	$ProgrammableBehaviour.lock_for_time(reload_time)

func _on_ProgrammableBehaviour_rotate(angle):
	rotate(angle)

func _on_ProgrammableBehaviour_sensor_detect(out_dict, id: int = -1):
	if (id == -1): # Self sensor
		sensor_detect(out_dict)
	else: # Get sensor by index
		out_dict[0] = get_parent().get_node("Sensor%d" % id).detect()
