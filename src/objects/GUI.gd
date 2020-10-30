extends CanvasLayer

signal start_wave()
signal restart_level()
signal next_level()
signal update_code_source(new_source, turret_name)
signal update_time_scale(new_time_scale)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var wave_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Start button pressed, signal to start wave
func _on_StartButton_pressed():
	if !wave_started:
		emit_signal("start_wave")
		enable_speed_buttons()
	_on_Speed1Button_pressed()

# Reset the gui
func reset():
	$CodeWindow.reset()
	wave_started = false
	disable_speed_buttons()
	show_pause_button(false)
	
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
	show_pause_button(true)

func _on_Speed2Button_pressed():
	enable_speed_buttons()
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed2Button.disabled = true
	emit_signal("update_time_scale", 3)
	show_pause_button(true)

func _on_Speed3Button_pressed():
	enable_speed_buttons()
	$LevelControlsPanel/MarginContainer/HBoxContainer/Speed3Button.disabled = true
	emit_signal("update_time_scale", 5)
	show_pause_button(true)

func _on_PauseButton2_pressed():
	enable_speed_buttons()
	emit_signal("update_time_scale", 0.001)
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
	_on_StartButton_pressed()
