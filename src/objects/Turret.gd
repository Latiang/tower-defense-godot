extends Area2D

export (PackedScene) var Bullet

signal turret_pressed(turret)

export var id = 0;
export var can_rotate = true
export var integrated_sensor = true
export var can_move = false
export var reload_time = 0.3 #seconds

var time_scale = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	pass

func fire():
	var dir = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
	$Gun.spawn_bullet(position, dir, time_scale)

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
	$ProgrammableBehaviour.lock_for_time(reload_time / time_scale)

func _on_ProgrammableBehaviour_rotate(angle):
	rotate(angle)

func _on_ProgrammableBehaviour_sensor_detect(out_dict, id: int = -1):
	if (id == -1): # Self sensor
		sensor_detect(out_dict)
	else: # Get sensor by index
		out_dict[0] = get_parent().get_node("Sensor%d" % id).detect()

# Pressing on turret opens code window
func _on_Turret_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and !get_parent().wave_started:
		emit_signal("turret_pressed", self)
		
func update_source(new_source):
	$ProgrammableBehaviour/CodeInterpreter.code_source = new_source

func get_code_source():
	return $ProgrammableBehaviour/CodeInterpreter.code_source

func update_time_scale(new_time_scale):
	$ProgrammableBehaviour/LockTimer.start($ProgrammableBehaviour/LockTimer.time_left * (float(time_scale) / new_time_scale))
	time_scale = new_time_scale
	$Gun.update_bullet_speeds(new_time_scale)
