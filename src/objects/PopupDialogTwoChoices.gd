tool
extends PanelContainer

signal button1_pressed()
signal button2_pressed()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var text = ""
export var button1_text = ""
export var button2_text = ""
export var close_on_press = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/MarginContainer2/Label.text = text
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Button1.text = button1_text
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Button2.text = button2_text

func _on_Button1_pressed():
	emit_signal("button1_pressed")
	if close_on_press:
		visible = false

func _on_Button2_pressed():
	emit_signal("button2_pressed")
	if close_on_press:
		visible = false

func setText(text):
	$MarginContainer/VBoxContainer/MarginContainer2/Label.text = text
