extends CanvasLayer

signal start_wave()
signal restart_level()
signal next_level()
signal return_to_main_menu()
signal update_code_source(new_source, turret_name)
signal update_time_scale(new_time_scale)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var wave_started = false
var escape_menu_open = false
var current_time_scale = 1

var error_line = 0
var force_debug_cursor_position = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	set_coordinate_label()
	if force_debug_cursor_position:
		$CodeWindow.highlight_code_line(error_line)
	
func _input(event):
	if $LevelControlsPanel.visible:
		if event.is_action_pressed("escape_menu_toggle") and !event.is_echo():
			toggle_escape_menu()
		
func update_level_data(data):
	$LevelNamePanel/MarginContainer/HBoxContainer/LevelCountLabel.text = "Level %s" % data["count"]
	$LevelNamePanel/MarginContainer/HBoxContainer/CenterContainer/LevelNameLabel.text = data["description"]
		
func toggle_escape_menu():
	escape_menu_open = !escape_menu_open
	if escape_menu_open:
		$PopupGreyCover.show()
		$EscapeMenu.show()
		emit_signal("update_time_scale", 0.0001)
	else:
		$PopupGreyCover.hide()
		$EscapeMenu.hide()
		emit_signal("update_time_scale", current_time_scale)
			
func set_coordinate_label():
	if $CoordinateLabel.visible:
		var pos = get_viewport().get_mouse_position()
		$CoordinateLabel.text = "(%d, %d)" % [pos.x, pos.y]

func hide():
	$CodeWindow.hide()
	$LevelControlsPanel.hide()
	$HealthPanel.hide()
	$CoordinateLabel.hide()
	$EscapeMenu.hide()
	$LevelNamePanel.hide()

func show():
	$CodeWindow.show()
	$LevelControlsPanel.show()
	$HealthPanel.show()
	$CoordinateLabel.show()
	$EscapeMenu.hide()
	$LevelNamePanel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Start button pressed, signal to start wave
func _on_StartButton_pressed():
	if !wave_started:
		emit_signal("start_wave")
		enable_speed_buttons()
	_on_Speed1Button_pressed()
	$CodeWindow.set_execution_mode()

# Reset the gui
func reset():
	$CodeWindow.reset()
	wave_started = false
	disable_speed_buttons()
	show_pause_button(false)
	$CodeWindow.set_coding_mode()
	if error_line: # Start cursor on error line
		$CodeWindow/VBoxContainer/MarginContainer/CodeEditor.grab_focus()
		force_debug_cursor_position = true
		$DebugLineCursorTimer.start()
		#error_line = 0
	
func level_lost():
	reset()
	$PopupGreyCover.visible = true
	$LostPopup.visible = true
	
func level_won():
	reset()
	$PopupGreyCover.visible = true
	$WonPopup.visible = true

# Update the health indicator
func update_health(health):
	$HealthPanel/MarginContainer/HBoxContainer/HealthLabel.text = str(health)

func _on_Speed1Button_pressed():
	enable_speed_buttons()
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed1Button.disabled = true
	emit_signal("update_time_scale", 1)
	current_time_scale = 1
	show_pause_button(true)

func _on_Speed2Button_pressed():
	enable_speed_buttons()
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed2Button.disabled = true
	emit_signal("update_time_scale", 3)
	current_time_scale = 3
	show_pause_button(true)

func _on_Speed3Button_pressed():
	enable_speed_buttons()
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed3Button.disabled = true
	emit_signal("update_time_scale", 5)
	current_time_scale = 5
	show_pause_button(true)

func _on_PauseButton2_pressed():
	enable_speed_buttons()
	emit_signal("update_time_scale", 0.001)
	current_time_scale = 0.001
	# Enable play button instead
	show_pause_button(false)

func enable_speed_buttons():
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed1Button.disabled = false
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed2Button.disabled = false
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed3Button.disabled = false
	
func disable_speed_buttons():
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed1Button.disabled = true
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed2Button.disabled = true
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed3Button.disabled = true
	
func show_pause_button(show_pause):
	$LevelControlsPanel/MarginContainer/HBoxContainer/StartButton.visible = !show_pause
	$LevelControlsPanel/MarginContainer/HBoxContainer/PauseButton.visible = show_pause

func show_debug_message(message):
	_on_PauseButton2_pressed()
	$DebugPopup.setText(message)
	$PopupGreyCover.visible = true
	$DebugPopup.visible = true

func _on_LostPopup_button_pressed():
	$PopupGreyCover.visible = false
	emit_signal("restart_level")

func _on_WonPopup_button_pressed():
	$PopupGreyCover.visible = false
	emit_signal("next_level")
	
# Return to edit phase
func _on_DebugPopup_button1_pressed():
	$PopupGreyCover.visible = false
	emit_signal("restart_level")

# Continue starting level
func _on_DebugPopup_button2_pressed():
	$PopupGreyCover.visible = false
	# Probably something more complicated required
	emit_signal("update_time_scale", current_time_scale)

# Return to Main Menu
func _on_EscapeMenu_exit():
	toggle_escape_menu()
	emit_signal("return_to_main_menu")

func _on_EscapeMenu_restart():
	toggle_escape_menu()
	emit_signal("restart_level")

func _on_EscapeMenu_resume():
	toggle_escape_menu()

func _on_EscapeMenu_settings():
	pass # Replace with function body.

func _on_turret_code_error(id, error_message, error_line):
	$PopupGreyCover.visible = true
	$DebugPopup.set_text("Error in line %d in Turret %d:\n%s" % [error_line, id, error_message])
	$DebugPopup.visible = true
	self.error_line = error_line
	emit_signal("update_time_scale", 0.001)


func _on_DebugLineCursorTimer_timeout():
	force_debug_cursor_position = false
	error_line = 0
