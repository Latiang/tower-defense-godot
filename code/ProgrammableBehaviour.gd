extends Node

# Output functions
signal fire()
signal rotate(angle)

var code_str

var locked = false

func _ready():
	pass
	
# Run every frame. Shoot bullet if mouse pressed
func _process(delta):
	# Functionality that is not time locked
	var angle = get_parent().position.angle_to_point(get_viewport().get_mouse_position()) - PI/2
	emit_signal("rotate", angle)
	# Time locked functonality such as shooting
	if (!locked):
		if Input.is_action_pressed("mouse_left_click"):
			emit_signal("fire")

func lock_for_time(time):
	locked = true
	$LockTimer.start(time)

func _on_LockTimer_timeout():
	locked = false
