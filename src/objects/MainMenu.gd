extends CanvasLayer

signal start_level(level_number)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide():
	$TitleMenu.hide()
	$LevelSelectionMenu.hide()

func show():
	$TitleMenu.show()
	$LevelSelectionMenu.show()

# Open level selection menu
func _on_PlayButton_pressed():
	$TitleMenu.hide()
	$LevelSelectionMenu.show()

func _on_SettingsButton_pressed():
	pass # Replace with function body.

# Exit game
func _on_ExitButton_pressed():
	get_tree().quit()
	
func _on_level_button_pressed(level_number):
	emit_signal("start_level", level_number)
	print("[Main Menu] Level %d selected" % level_number)
