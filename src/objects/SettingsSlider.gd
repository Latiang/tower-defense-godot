tool
extends Control

export var label = ""
export var slider_left_label = "0"
export var slider_right_label = "100"
export var slider_min = 0
export var slider_max = 100
export var slider_step = 1

signal slider_changed(value)

func _ready():
	update_children_properties()


func update_children_properties():
	$HBoxContainer/Label.text = label
	$HBoxContainer/CenterContainer/VBoxContainer/HSlider.min_value = slider_min
	$HBoxContainer/CenterContainer/VBoxContainer/HSlider.max_value = slider_max
	$HBoxContainer/CenterContainer/VBoxContainer/HSlider.step = slider_step
	$HBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/MarginContainer/SliderLeftLabel.text = slider_left_label
	$HBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/MarginContainer2/SliderRightLabel.text = slider_right_label
	$HBoxContainer/Label.text = label

func _on_HSlider_value_changed(value):
	emit_signal("slider_changed", value)
