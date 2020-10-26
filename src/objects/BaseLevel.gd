extends CanvasLayer

var wave_started = false

signal open_code_window(turret)
signal level_complete()

var screen_width = 1280
var screen_height = 720

var time_scale = 1

# Level start.
func _ready():
	connect_turret_signals()

# Close the level and unload everything
func close():
	queue_free()

func _process(delta):
	if wave_started:
		update_scaling()
		check_for_win()

func set_time_scale(new_time_scale):
	time_scale = new_time_scale
	if wave_started:
		for child in self.get_children():
			if child.is_in_group("Turret") || child.is_in_group("MobPath"):
				child.update_time_scale(new_time_scale)

func update_scaling():
	pass
	#var new_width = get_viewport().size.x
	#var new_height = get_viewport().size.y
	#if (new_width != screen_width):
		#scale.x = float(new_width) / 1280
	#if (new_height != screen_height):
		#scale.y = float(new_height) / 720

# Start the waves for this level
func start_wave():
	wave_started = true
	# Modify objects in the level to represent starting wave state
	for child in self.get_children():
		if child.is_in_group("Turret"):
			child.get_node("ProgrammableBehaviour").locked = false
		elif child.is_in_group("MobPath"):
			child.start_spawning_time()

func end_wave():
	wave_started = false
	# Modify objects in the level to represent starting wave state
	for child in self.get_children():
		if child.is_in_group("Turret"):
			child.get_node("ProgrammableBehaviour").lock()
	emit_signal("level_complete")

func _on_Turret_turret_pressed(turret):
	emit_signal("open_code_window", turret.id)

# Connect the turret pressed signal to open_code_window
func connect_turret_signals():
	for child in self.get_children():
		if child.is_in_group("Turret"):
			child.connect("turret_pressed", self, "_on_Turret_turret_pressed")
			# Add reference to this turret in the GUI
			get_parent().get_node("GUI").get_node("CodeWindow").add_turret_button(child)
			
# Checks whether the wave has been won
func check_for_win():
	var spawning_complete = true
	for child in self.get_children():
		if child.is_in_group("MobPath"):
			spawning_complete = (spawning_complete && child.spawning_complete)
	# All spawning is complete. Check for living enemies
	if spawning_complete:
		var no_enemies_left = true
		for child in self.get_children():
			if child.is_in_group("MobPath"):
				no_enemies_left = (no_enemies_left && len(child.get_children()) == 1)
		if no_enemies_left:
			end_wave()
