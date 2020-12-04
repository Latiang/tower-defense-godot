extends CanvasLayer

signal start_level(level_number)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide():
	$TitleMenu.hide()
	$LevelSelectionMenu.hide()
	$BackgroundTexture.hide()
	$SettingsMenu.hide()

func show():
	$TitleMenu.show()
	$LevelSelectionMenu.show()
	$BackgroundTexture.show()

# Open level selection menu
func _on_PlayButton_pressed():
	$TitleMenu.hide()
	$LevelSelectionMenu.show()

func _on_SettingsButton_pressed():
	$TitleMenu.hide()
	$SettingsMenu.display()

# Exit game
func _on_ExitButton_pressed():
	get_tree().quit()
	
func _on_level_button_pressed(level_number):
	emit_signal("start_level", level_number)
	print("[Main Menu] Level %d selected" % level_number)

func _on_SettingsMenu_close_settings_menu():
	$TitleMenu.show()
	$SettingsMenu.hide()

func _on_SettingsMenu_update_setting_effects():
	# Propagate settings change
	get_parent().propagate_settings_change()

# Return to main menu
func _on_LevelSelectBackButton_pressed():
	$TitleMenu.show()
	$LevelSelectionMenu.hide()

