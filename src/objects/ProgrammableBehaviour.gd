extends Node

# Output functions
signal fire()
signal rotate(angle)
signal sensor_detect(out_dict, id)

var locked = true

var printnow = false

# Input variables
var out_hit = false;

func _ready():
	pass
	
# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	# Functionality that is not time locked (temporary)
	var angle = get_parent().position.angle_to_point(get_viewport().get_mouse_position()) - PI/2
	emit_signal("rotate", angle)
	# Time locked functonality, such as code execution
	if (!locked):
		#$CodeInterpreter.run()
		if Input.is_action_pressed("mouse_left_click"):
			emit_signal("fire")
			#$CodeInterpreter.run()

# Lock the object from executing code for a certain amount of time
func lock_for_time(time):
	locked = true
	$LockTimer.start(time)

# Disable lock
func _on_LockTimer_timeout():
	locked = false
