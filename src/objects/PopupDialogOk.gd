tool
extends PanelContainer

signal button_pressed()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var text = ""
export var button_text = ""
export var close_on_press = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/MarginContainer2/Label.text = text
	$MarginContainer/VBoxContainer/MarginContainer/Button.text = button_text

func set_text(text):
	$MarginContainer/VBoxContainer/MarginContainer2/Label.text = text

func _on_Button_pressed():
	emit_signal("button_pressed")
	if close_on_press:
		visible = false
