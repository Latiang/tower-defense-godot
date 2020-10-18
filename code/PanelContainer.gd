extends Panel

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
		$VBoxContainer/MarginContainer/CodeEditor.add_keyword_color(keyword, keyword_color)
	# String highlighting
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("\"", "\"", string_color)
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("'", "'", string_color)
	# Comment highlighting
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("#", "", comments_color, true)
	$VBoxContainer/MarginContainer/CodeEditor.add_color_region("//", "", comments_color, true)


func _on_SaveButton_pressed():
	emit_signal("save_and_close", $VBoxContainer/MarginContainer/CodeEditor.text)
