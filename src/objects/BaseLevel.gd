extends Node

var wave_started = false

signal open_code_window(turret)

# Level start.
func _ready():
	connect_turret_signals()

# Close the level and unload everything
func close():
	queue_free()

# Start the waves for this level
func start_wave():
	wave_started = true
	# Modify objects in the level to represent starting wave state
	for child in self.get_children():
		if child.is_in_group("Turret"):
			child.get_node("ProgrammableBehaviour").locked = false
		elif child.is_in_group("MobPath"):
			child.start_spawning_time()

func _on_Turret_turret_pressed(turret):
	emit_signal("open_code_window", turret)

# Connect the turret pressed signal to open_code_window
func connect_turret_signals():
	for child in self.get_children():
		if child.is_in_group("Turret"):
			child.connect("turret_pressed", self, "_on_Turret_turret_pressed")
