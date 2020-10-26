extends CanvasLayer

signal start_wave()
signal update_code_source(new_source, turret_name)
signal update_time_scale(new_time_scale)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Start button pressed, signal to start wave
func _on_StartButton_pressed():
	emit_signal("start_wave")
	enable_speed_buttons()

# Reset the gui
func reset():
	$CodeWindow.reset()


func _on_Speed1Button_pressed():
	enable_speed_buttons()
	$LevelButtonsPanel/MarginContainer/HBoxContainer/Speed1Button.disabled = true
	emit_signal("update_time_scale", 1)

func _on_Speed2Button_pressed():
	enable_speed_buttons()
	$LevelButtonsPanel/MarginContainer/HBoxContainer/Speed2Button.disabled = true
	emit_signal("update_time_scale", 2)

func _on_Speed3Button_pressed():
	enable_speed_buttons()
	$LevelButtonsPanel/MarginContainer/HBoxContainer/Speed3Button.disabled = true
	emit_signal("update_time_scale", 3)

func enable_speed_buttons():
	$LevelButtonsPanel/MarginContainer/HBoxContainer/Speed1Button.disabled = false
	$LevelButtonsPanel/MarginContainer/HBoxContainer/Speed2Button.disabled = false
	$LevelButtonsPanel/MarginContainer/HBoxContainer/Speed3Button.disabled = false
