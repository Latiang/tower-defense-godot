extends CanvasLayer

signal save_and_close(new_code_source)

export var keyword_color = Color("d32929")
export var keywords = "if while for def switch"
export var string_color = Color("dddd30")
export var comments_color = Color("27b441")

func _ready():
	register_keywords()

func register_keywords():
	var keywords_list = keywords.split(" ")
	for keyword in keywords_list:
		$Panel/VBoxContainer/MarginContainer/CodeEditor.add_keyword_color(keyword, keyword_color)
	# String highlighting
	$Panel/VBoxContainer/MarginContainer/CodeEditor.add_color_region("\"", "\"", string_color)
	$Panel/VBoxContainer/MarginContainer/CodeEditor.add_color_region("'", "'", string_color)
	# Comment highlighting
	$Panel/VBoxContainer/MarginContainer/CodeEditor.add_color_region("#", "", comments_color, true)
	$Panel/VBoxContainer/MarginContainer/CodeEditor.add_color_region("//", "", comments_color, true)


func _on_SaveButton_pressed():
	emit_signal("save_and_close", $Panel/VBoxContainer/MarginContainer/CodeEditor.text)

func _on_Turret_open_code_window(pos):
	$Panel.visible = true
	$Panel.rect_position = pos
	$Panel/VBoxContainer/MarginContainer/CodeEditor.text = $"../Turret/ProgrammableBehaviour/CodeInterpreter".code_source
