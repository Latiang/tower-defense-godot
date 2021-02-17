extends Node

var current_level = false
var current_level_index = 0

export var max_health = 5
var health = max_health

var save_state = load("res://objects/SaveStateClass.gd").new()

func _ready():
	pass

func _on_AutoSaveTimer_timeout():
	if current_level && !current_level.wave_started:
		$GUI/CodeWindow.save_code_to_turret()
		save_state.save_level_data(current_level, current_level_index, 2)
		save_state.save_to_file()
		print("[Level] Autosaving level")

func save_level():
	$GUI/CodeWindow.save_code_to_turret()
	save_state.save_level_data(current_level, current_level_index, 2)
	save_state.save_to_file()
	print("[Level] Saving level")

# Handle input for debugging purposes
var level_toggle = false
func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_F1) and just_pressed:
		# Switch between levels with F1
		_on_GUI_next_level()

# Load a level by name. Connects the required signals and so on
func load_level(level_index, popups_enabled=true):
	get_parent().propagate_settings_change()
	health = max_health
	current_level_index = level_index
	var level_name = save_state.get_level_data(level_index)["file"]
	$GUI.reset()
	$GUI.update_health(health)
	$GUI.update_level_data(save_state.get_level_data(level_index))
	if $GUI.tutorial_popups_enabled:
		$GUI.tutorial_popups_enabled = popups_enabled
	$GUI.update_tutorial_popups(save_state.get_tutorial_popups(level_index))
	print("[Level] Loading level: %s" % level_name)
	if current_level:
		current_level.close()
		current_level = null
	current_level = load("res://levels/%s.tscn" % level_name).instance()
	add_child(current_level)
	# Connect the signals needed
	current_level.connect("open_code_window", self, "_on_Level_open_code_window")
	current_level.connect("level_complete", self, "_on_Level_level_complete")
	# Load turret code and such from file
	save_state.load_level_data(current_level, current_level_index)
	$GUI/CodeWindow.open_code_window(0, false)
	
	if get_parent().autosave_enabled:
		$AutoSaveTimer.start()

	save_state.save_level_data(current_level, current_level_index, 2)

# Start a level wave (start button pressed)
func _on_GUI_start_wave():
	if !current_level.wave_started:
		$GUI/CodeWindow.save_code_to_turret()
		save_level()
		current_level.start_wave()

# Open a code window for a specific turret, send to GUI
func _on_Level_open_code_window(turret_id):
	$GUI/CodeWindow.open_code_window(turret_id)

func _on_Level_level_complete():
	if health > 0:
		# Unlock next level
		if current_level_index + 1 < save_state.level_count:
			save_state.unlock_level(current_level_index+1)
		$GUI.level_won()
		$AutoSaveTimer.stop()
		save_state.save_level_data(current_level, current_level_index, 3)
		save_state.save_to_file()

func _on_GUI_update_time_scale(new_time_scale, continue_interpreting=true):
	current_level.set_time_scale(new_time_scale, continue_interpreting)
	
func _on_Level_base_damage(damage):
	health -= damage
	$GUI.update_health(health)
	if (health <= 0): # Level lost
		current_level.set_time_scale(0.0001, false)
		$GUI.level_lost()

func _on_GUI_restart_level():
	load_level(current_level_index, false)
	
func _on_GUI_next_level():
	if current_level_index + 1 < save_state.level_count:
		load_level(current_level_index + 1)
	else: # Return to main menu if no more levels are left
		get_parent().show_MainMenu()
	
func debug_tick_interpreter_once():
	current_level.tick_once
	
