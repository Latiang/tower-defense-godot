tool
extends Control

export var label = ""

signal toggled(state)

func _ready():
	update_children_properties()


func update_children_properties():
	$MarginContainer/HBoxContainer/Label.text = label
	
func set_state(state):
	$MarginContainer/HBoxContainer/Checkbox.pressed = state

func get_state():
	return $MarginContainer/HBoxContainer/Checkbox.pressed 

func _on_Checkbox_toggled(button_pressed):
	emit_signal("toggled", button_pressed)
