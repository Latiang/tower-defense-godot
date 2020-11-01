extends Node

func _ready():
	# Load save
	$MainMenu/LevelSelectionMenu.populate_level_buttons($LevelManager.save_state)
	#$MainMenu.hide()
	$LevelManager/GUI.hide()


func _on_MainMenu_start_level(level_number):
	$MainMenu.hide()
	$LevelManager/GUI.show()
	$LevelManager.load_level(level_number)
