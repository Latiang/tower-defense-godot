extends Node

export var debug_main_menu_override = false
export var debug_tick_interpreter_once = false
export var autosave_enabled = true

func _ready():
	# Load main menu
	if !debug_main_menu_override:
		$MainMenu/LevelSelectionMenu.populate_level_buttons($LevelManager.save_state)
		show_MainMenu()
	else: # Load first level for debugging
		_on_MainMenu_start_level(0)
		if debug_tick_interpreter_once:
			$LevelManager.current_level.debug_tick_interpreter_once()

func _input(event):
	if event.is_action_pressed("fullscreen_toggle") and !event.is_echo():
		OS.window_fullscreen = !OS.window_fullscreen

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
