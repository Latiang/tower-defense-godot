extends Node

export var debug_main_menu_override = false
export var debug_tick_interpreter_once = false
export var autosave_enabled = true

var settings_state = load("res://objects/SettingsStateClass.gd").new()

func _ready():
	# Load main menu
	$MainMenu/LevelSelectionMenu.populate_level_buttons($LevelManager.save_state)
	if !debug_main_menu_override:
		show_MainMenu()
	else: # Load first level for debugging
		_on_MainMenu_start_level(0)
		if debug_tick_interpreter_once:
			$LevelManager.current_level.debug_tick_interpreter_once()
	settings_state.load_from_file()
	$MainMenu/SettingsMenu.settings_state = settings_state
	$LevelManager/GUI/SettingsMenu.settings_state = settings_state
	propagate_settings_change()
	$SoundManager.connect_button_sound_signals()
	$SoundManager.start_music()

func _input(event):
	if event.is_action_pressed("fullscreen_toggle") and !event.is_echo():
		settings_state.set("fullscreen", !settings_state.get("fullscreen"))
		propagate_settings_change()
	elif event.is_action_pressed("screenshot") and !event.is_echo():
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		# Date format ISO 2020-12-08T20:36:30
		var date_dict = OS.get_datetime()
		for item in date_dict: # Pad the numbers correctly, ex 7 -> 07
			date_dict[item] = "%02d" % int(date_dict[item])
		var date_str = "{year}-{month}-{day}T{hour}:{minute}:{second}".format(date_dict)
		image.save_png("screenshots/screenshot%s" % date_str)

func _on_MainMenu_start_level(level_number):
	show_level()
	$LevelManager.load_level(level_number)

func show_MainMenu():
	$MainMenu.show()
	$MainMenu/LevelSelectionMenu.hide()
	$LevelManager/GUI.hide()
	if $LevelManager.current_level:
		$LevelManager.current_level.queue_free()
	
func show_level():
	$MainMenu.hide()
	$LevelManager/GUI.show()

func _on_GUI_return_to_main_menu():
	show_MainMenu()
	
func propagate_settings_change():
	$LevelManager/GUI.update_setting_effects(settings_state)
	OS.window_fullscreen = settings_state.get("fullscreen")
	$SoundManager.update_sound_settings(settings_state)
