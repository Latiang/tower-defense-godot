extends Panel

export var keyword_color = Color("d32929")
export var keywords = "if while for def switch"
export var string_color = Color("dddd30")
export var comments_color = Color("27b441")

# Reference to the turret currently having code edited
var current_turret

func _ready():
	setup_code_syntax_highlighting()

# Register keywords and other syntax highlighting for the CodeEditor
func setup_code_syntax_highlighting():
	var keywords_list = keywords.split(" ")
	for keyword in keywords_list:
		$VBoxContainer/MarginContainer/CodeEditor.add_keyword_color(keyword, keyword_color)
	# String highlighting
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("\"", "\"", string_color)
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("'", "'", string_color)
	# Comment highlighting
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("#", "", comments_color, true)
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("//", "", comments_color, true)

# Save button pressed, save the edited code in the turret object
func _on_SaveButton_pressed():
	visible = false
	current_turret.update_source($VBoxContainer/MarginContainer/CodeEditor.text)

# Open a code window for this turret, caused by pressing a turret
func open_code_window(turret):
	visible = true
	rect_position = turret.position
	$VBoxContainer/MarginContainer/CodeEditor.text = turret.get_code_source()
	current_turret = turret
