extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var save_state = {"levels": ["name", status, ["turret1_code", "turret2_code"]]}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func populate_level_buttons(save_state):
	
