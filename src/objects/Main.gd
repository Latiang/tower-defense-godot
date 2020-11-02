extends Node

var current_level = false

var health = 100

func _ready():
	load_level("TestLevel1")
	print("Running interpreter once for debug")
	tick_once()

func tick_once():
	for child in self.current_level.get_children():
			if child.is_in_group("Turret"):
				child.get_node("ProgrammableBehaviour").get_node("CodeInterpreter").run()

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
			load_level("TestLevel1")

# Load a level by name. Connects the required signals and so on
func load_level(name):
	health = 100
	$GUI.reset()
	print("Loading level: %s" % name)
	if current_level:
		current_level.close()
	current_level = load("res://levels/%s.tscn" % name).instance()
	add_child(current_level)
	# Connect the signals needed
	current_level.connect("open_code_window", self, "_on_Level_open_code_window")
	current_level.connect("level_complete", self, "_on_Level_level_complete")
	$GUI/CodeWindow.open_code_window(0)

# Start a level wave (start button pressed)
func _on_GUI_start_wave():
	if !current_level.wave_started:
		current_level.start_wave()

# Open a code window for a specific turret, send to GUI
func _on_Level_open_code_window(turret_id):
	$GUI/CodeWindow.open_code_window(turret_id)

func _on_Level_level_complete():
	print("Win condition for level reached")
	$GUI.reset()

func _on_GUI_update_time_scale(new_time_scale):
	current_level.set_time_scale(new_time_scale)
	
func _on_Level_base_damage(damage):
	health -= damage
	$GUI.update_health(health)
