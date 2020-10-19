extends Node

var current_level = false

func _ready():
	load_level("TestLevel")

# Handle input for debugging purposes
var level_toggle = false
func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_F1) and just_pressed:
		# Switch between two levels on 'C'
		level_toggle = !level_toggle
		if level_toggle:
			load_level("TestLevel2")
		else:
			load_level("TestLevel")

# Load a level by name. Connects the required signals and so on
func load_level(name):
	print("Loading level: %s" % name)
	if current_level:
		current_level.close()
	current_level = load("res://levels/%s.tscn" % name).instance()
	add_child(current_level)
	# Connect the signals needed
	current_level.connect("open_code_window", self, "_on_Level_open_code_window")
	$GUI.reset()

# Start a level wave (start button pressed)
func _on_GUI_start_wave():
	if !current_level.wave_started:
		current_level.start_wave()

# Open a code window for a specific turret, send to GUI
func _on_Level_open_code_window(turret):
	$GUI/CodeWindow.open_code_window(turret)
