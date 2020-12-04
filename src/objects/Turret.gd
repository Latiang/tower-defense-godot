extends Area2D

export (PackedScene) var Bullet

signal turret_pressed(turret)
signal code_error(id, error_message, error_line)

export var id = 0;
export var can_rotate = true
export var rotation_speed = 260 # Degrees/s
export var integrated_sensor = true
export var can_move = true
export var move_speed = 100 # Pixels/s 
export var unlimited_ammo = true
export var ammo_count = 50
export var reload_time = 0.3 # Seconds

var time_scale = 1
var distance_to_move = 0
var direction_right : bool = false

var distance_to_rotate = 0

func _ready():
	 $SensorLine.visible = integrated_sensor
		

func _process(delta):
	if can_rotate and (distance_to_rotate > 0.01 or distance_to_rotate < -0.01):
		var dist = deg2rad(rotation_speed) * delta * time_scale
		if (distance_to_rotate < 0):
			dist = -dist
			if (distance_to_rotate - dist > 0):
				dist = distance_to_rotate
				distance_to_rotate = 0
			else:
				distance_to_rotate -= dist
		else:
			if (distance_to_rotate - dist < 0):
				dist = distance_to_rotate
				distance_to_rotate = 0
			else:
				distance_to_rotate -= dist
		rotation += dist
			
	elif can_move and distance_to_move > 0 and $MovablePath/PathFollow2D.unit_offset < 1:
		 # Ugly fix, translate position temporarily so that this acts in world space
		position = position - $MovablePath/PathFollow2D.position
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
	if unlimited_ammo or ammo_count > 0:
		var dir = Vector2(cos(rotation + PI), sin(rotation + PI))
		$Gun.spawn_bullet(position, dir, time_scale)
		ammo_count -= 1

func rotate(angle):
	if can_rotate:
		distance_to_rotate = -fmod(rotation + angle, 2*PI)

func sensor_detect(out_dict):
	if (integrated_sensor):
		out_dict[0] = $SensorCast.is_colliding()
	else:
		out_dict[0] = false

func _on_ProgrammableBehaviour_turret_position(out_dict):
	out_dict[0] = Vector2(position.x, 1080-position.y)

func _on_ProgrammableBehaviour_fire():
	fire()
	if ammo_count > 0:
		$ProgrammableBehaviour.lock_for_time(reload_time / time_scale)

func _on_ProgrammableBehaviour_rotate(angle):
	var move_angle = fmod(rotation + angle, 2*PI)
	rotate(angle)
	if can_rotate:
		$ProgrammableBehaviour.lock_for_time(abs(move_angle) / (deg2rad(rotation_speed) * time_scale))
	
func _on_ProgrammableBehaviour_move(distance):
	move(distance)
	if can_move:
		$ProgrammableBehaviour.lock_for_time(float(distance) / (time_scale * move_speed))

func _on_ProgrammableBehaviour_sensor_detect(out_dict, id: int = -1):
	if (id == -1): # Self sensor
		sensor_detect(out_dict)
	else: # Get sensor by index
		var sensor = get_parent().get_node("Sensor%d" % id)
		if sensor == null:
			out_dict[0] = null
		else:
			out_dict[0] = sensor.detect()

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

func _on_ProgrammableBehaviour_code_error(error_message, error_line):
	emit_signal("code_error", id, error_message, error_line)


func _on_ProgrammableBehaviour_sleep(time):
	$ProgrammableBehaviour.lock_for_time(time / time_scale)
