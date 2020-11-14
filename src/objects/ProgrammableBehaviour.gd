extends Node

# Output functions
signal fire()
signal rotate(angle)
signal move(distance)
signal sensor_detect(out_dict, id)

signal code_error(error_message, error_line)

var allow_interpreting = false
var locked = true
var printnow = false

var frames_testing = 0

func _ready():
	pass
	
# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	frames_testing += 1
	
	# Functionality that is not time locked (temporary)
	#var angle = get_parent().position.angle_to_point(get_viewport().get_mouse_position()) - PI/2
	#emit_signal("rotate", angle)
	# Time locked functonality, such as code execution
	if (!locked):
		$CodeInterpreter.run()
		if Input.is_action_pressed("mouse_left_click"):
			emit_signal("fire")
			$CodeInterpreter.run()
		elif Input.is_key_pressed(KEY_A):
			emit_signal("move", -20)
		elif Input.is_key_pressed(KEY_D):
			emit_signal("move", 20)

# Lock the object from executing code for a certain amount of time
func lock_for_time(time):
	locked = true
	$LockTimer.start(time)
	
func report_error(error, line):
	emit_signal("code_error", error, line)

# Disable lock
func _on_LockTimer_timeout():
	if allow_interpreting:
		locked = false
	
func lock():
	$LockTimer.stop()
	locked = true
