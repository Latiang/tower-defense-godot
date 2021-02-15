extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var i = 0
var first_run = true

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
	# Set back button to last
	if first_run:
		$MarginContainer/VBoxContainer.move_child($MarginContainer/VBoxContainer/ButtonMarginContainer, i)
		first_run = false
	else:
		# Reconnect sound signals
		get_parent().get_parent().get_node("SoundManager").connect_button_sound_signals()
		$MarginContainer/VBoxContainer.move_child($MarginContainer/VBoxContainer/ButtonMarginContainer, i*2)
	

func depopulate_level_buttons():
	for child in $MarginContainer/VBoxContainer.get_children():
		if child is LevelSelectNode:
			child.queue_free()
