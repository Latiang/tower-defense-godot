tool
extends PanelContainer

signal button_pressed()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/MarginContainer2/RichTextLabel.text = text
	
func popup(pos, text):
	set_position(pos)
	$MarginContainer/VBoxContainer/MarginContainer2/RichTextLabel.bbcode_text = text
	show()

func _on_Button_pressed():
	emit_signal("button_pressed")
