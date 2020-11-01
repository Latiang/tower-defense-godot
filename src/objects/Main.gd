extends Node

export var debug_main_menu_override = false
export var debug_tick_interpreter_once = false

func _ready():
	# Load main menu
	if !debug_main_menu_override:
		$MainMenu/LevelSelectionMenu.populate_level_buttons($LevelManager.save_state)
		$LevelManager/GUI.hide()
	else: # Load first level for debugging
		_on_MainMenu_start_level(0)
		if debug_tick_interpreter_once:
			$LevelManager.current_level.debug_tick_interpreter_once()

func _on_MainMenu_start_level(level_number):
	$MainMenu.hide()
	$LevelManager/GUI.show()
	$LevelManager.load_level(level_number)
