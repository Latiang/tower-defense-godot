extends Area2D

export (PackedScene) var Bullet

signal turret_pressed(turret)

export var id = 0;
export var can_rotate = true
export var integrated_sensor = true
export var can_move = true
export var move_speed = 100
export var reload_time = 0.3 #seconds

var time_scale = 1
var distance_to_move = 0
var direction_right : bool = false

func _ready():
	print($MovablePath.position)

func _process(delta):
	if can_move and distance_to_move > 0 and $MovablePath/PathFollow2D.unit_offset < 1:
		position = position - $MovablePath/PathFollow2D.position # Ugly fix
		var offset = move_speed * delta * time_scale
		offset = distance_to_move if ((distance_to_move - offset) < 0) else offset
		distance_to_move -= offset
		$MovablePath/PathFollow2D.offset += offset if direction_right else -offset
		position = position + $MovablePath/PathFollow2D.position

func move(distance):
	if (can_move):
		distance_to_move = abs(distance)
		direction_right = (distance > 0)
			
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
	
func _on_ProgrammableBehaviour_move(distance):
	move(distance)
	$ProgrammableBehaviour.lock_for_time(float(distance) / (time_scale * move_speed))

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
	if $ProgrammableBehaviour.locked:
		var new_time = $ProgrammableBehaviour/LockTimer.time_left * (float(time_scale) / new_time_scale)
		$ProgrammableBehaviour/LockTimer.start(new_time)
	time_scale = new_time_scale
	$Gun.update_bullet_speeds(new_time_scale)

