extends CanvasLayer

signal start_wave()
signal update_code_source(new_source, turret_name)

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
	$CodeWindow.visible = false
	emit_signal("start_wave")

# Reset the gui
func reset():
	$CodeWindow.visible = false
