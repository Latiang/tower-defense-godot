tool
extends PanelContainer

class_name LevelSelectNode

signal pressed(level_number)

export var level_number = 1
export var level_name = ""
export var level_scene_name = ""

var locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_children_properties():
	$HBoxContainer/MarginContainer/LevelNumberLabel.text = "Level %d" % level_number
	$HBoxContainer/MarginContainer2/LevelNameLabel.text = level_name


func _on_LevelSelectNode_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and !locked:
		emit_signal("pressed", level_number-1)

func unlock():
	$HBoxContainer/MarginContainer3/LevelIcon.text = ""
	locked = false
	$GreyOutRect.visible = false

func lock():
	$HBoxContainer/MarginContainer3/LevelIcon.text = ""
	locked = true
	$GreyOutRect.visible = true
	
func completed():
	$HBoxContainer/MarginContainer3/LevelIcon.text = ""
	locked = false
	$GreyOutRect.visible = false
