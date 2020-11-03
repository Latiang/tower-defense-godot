extends Panel

export var keyword_color = Color("d32929")
export var keywords = "if while for def switch"
export var string_color = Color("dddd30")
export var comments_color = Color("27b441")

# Reference to the turret currently having code edited
var turrets = []
var current_turret_index = -1;

var turret_buttons = []
var icon_disabled_color = Color("b34747")
var icon_enabled_color = Color("50b347")
var icon_enabled_yellow_color = Color("c7c951")

func _ready():
	setup_code_syntax_highlighting()
	turrets.resize(10)

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
func save_code_to_turret():
	if (current_turret_index >= 0):
		turrets[current_turret_index].update_source($VBoxContainer/MarginContainer/CodeEditor.text)

# Open a code window for this turret, caused by pressing a turret
func open_code_window(id, save_current_open=true):
	if save_current_open:
		save_code_to_turret()
	$VBoxContainer/MarginContainer/CodeEditor.text = turrets[id].get_code_source()
	current_turret_index = id
	set_button_highlighting(id)
	set_turret_info_icons(id)

func add_turret_button(turret):
	turrets[turret.id] = turret
	# Add button
	if (turret.id != 0):
		var newButton = $VBoxContainer/Panel/HBoxContainer/TurretButton1.duplicate()
		newButton.text = "%d" % (turret.id + 1)
		newButton.disabled = false
		$VBoxContainer/Panel/HBoxContainer.add_child(newButton)
		turret_buttons.append(newButton)

# Remove excess turret buttons
func reset():
	for turret_button in turret_buttons:
		turret_button.queue_free()
	turret_buttons = []

func _on_TurretButton1_turret_button_pressed(button):
	open_code_window(int(button.text)-1)
	
func set_button_highlighting(id):
	if int($VBoxContainer/Panel/HBoxContainer/TurretButton1.text) == (id+1):
		$VBoxContainer/Panel/HBoxContainer/TurretButton1.disabled = true
	else:
		$VBoxContainer/Panel/HBoxContainer/TurretButton1.disabled = false
	for turret_button in turret_buttons:
		turret_button.disabled = (int(turret_button.text) == (id+1))

func set_turret_info_icons(id):
	var turret = turrets[id]
	var rotateIcon = $VBoxContainer/TurretInfoPanel/MarginContainer2/HBoxContainer/RotateIcon
	rotateIcon.add_color_override("font_color", icon_enabled_color if turret.can_rotate else icon_disabled_color)
	var sensorIcon = $VBoxContainer/TurretInfoPanel/MarginContainer2/HBoxContainer/SensorIcon
	sensorIcon.add_color_override("font_color", icon_enabled_color if turret.integrated_sensor else icon_disabled_color)
	var moveIcon = $VBoxContainer/TurretInfoPanel/MarginContainer2/HBoxContainer/MoveIcon
	moveIcon.add_color_override("font_color", icon_enabled_color if turret.can_move else icon_disabled_color)
	var bulletIcon = $VBoxContainer/TurretInfoPanel/MarginContainer2/HBoxContainer/MarginContainer/CenterContainer/BulletIcon
	if turret.unlimited_ammo:
		bulletIcon.modulate = icon_enabled_color
		bulletIcon.hint_tooltip = "Has Unlimited Ammo"
	else:
		bulletIcon.modulate = icon_enabled_yellow_color
		bulletIcon.hint_tooltip = "%d Ammo" % turret.ammo_count
