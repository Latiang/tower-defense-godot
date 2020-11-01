extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func populate_level_buttons(save_state):
	var level_panel = preload("res://objects/LevelSelectNode.tscn")
	var i = 1
	for level_info in save_state.get_level_states():
		var new_level_panel = level_panel.instance()
		new_level_panel.level_number = i
		new_level_panel.level_name = level_info["description"]
		new_level_panel.update_children_properties()
		if level_info["status"] == 0:
			new_level_panel.lock()
		elif level_info["status"] == 1 || level_info["status"] == 2:
			new_level_panel.unlock()
		elif level_info["status"] == 3:
			new_level_panel.completed()
		new_level_panel.connect("pressed", get_parent(), "_on_level_button_pressed")
		$MarginContainer/VBoxContainer.add_child(new_level_panel)
		i += 1
