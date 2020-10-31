tool
extends PanelContainer

signal pressed()

export var level_number = 1
export var level_name = ""
export var level_scene_name = ""

var locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lock()

func update_children_properties():
	$HBoxContainer/LevelNumberLabel.text = level_number
	$HBoxContainer/LevelNameLabel.text = level_number


func _on_LevelSelectNode_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and !locked:
		emit_signal("pressed")

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
