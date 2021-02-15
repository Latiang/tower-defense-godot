extends Node

# Output functions
# Functions which do not return a value
signal fire()
signal rotate(angle)
signal move(distance)
signal sleep(time)
# Functions which return a value
signal sensor_detect(out_dict, id)
signal turret_position(out_dict)

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
	if (!locked && allow_interpreting):
		$CodeInterpreter.run()

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
	
func stop_lock_timer():
	_on_LockTimer_timeout()
	$LockTimer.stop()
	
func lock():
	$LockTimer.stop()
	locked = true
