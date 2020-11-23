extends Control

signal close_settings_menu()
signal update_setting_effects()

onready var chkbx_tooltips = $PanelContainer/MarginContainer/VBoxContainer/GeneralMarginContainer/TooltipsCheckbox
onready var chkbx_fullscreen = $PanelContainer/MarginContainer/VBoxContainer/AppearanceMarginContainer/VBoxContainer/FullscreenCheckbox
onready var slider_codetextsize = $PanelContainer/MarginContainer/VBoxContainer/AppearanceMarginContainer/VBoxContainer/CodeTextSlider
onready var slider_master= $PanelContainer/MarginContainer/VBoxContainer/AudioMarginContainer/VBoxContainer/VolMasterSlider
onready var slider_music = $PanelContainer/MarginContainer/VBoxContainer/AudioMarginContainer/VBoxContainer/VolMusicSlider

# Set by main
var settings_state

func _ready():
	pass # Replace with function body.
	
func display():
	update_menu_from_state()
	show()

# Updates the various visual indicators for settings using settings state
func update_menu_from_state():
	chkbx_tooltips.set_state(settings_state.get("tutorial_tooltips"))
	chkbx_fullscreen.set_state(settings_state.get("fullscreen"))
	slider_codetextsize.set_state(settings_state.get("code_font_size"))
	slider_master.set_state(settings_state.get("master_volume"))
	slider_music.set_state(settings_state.get("music_volume"))

func update_state_from_menu():
	settings_state.set("tutorial_tooltips", chkbx_tooltips.get_state())
	settings_state.set("fullscreen", chkbx_fullscreen.get_state())
	settings_state.set("code_font_size", slider_codetextsize.get_state())
	settings_state.set("master_volume", slider_master.get_state())
	settings_state.set("music_volume", slider_music.get_state())
	settings_state.save_to_file()

func _on_BackButton_pressed():
	settings_state.save_to_file()
	emit_signal("close_settings_menu")

func _on_TooltipsCheckbox_toggled(state):
	settings_state.set("tutorial_tooltips", state)

func _on_FullscreenCheckbox_toggled(state):
	settings_state.set("fullscreen", state)

func _on_CodeTextSlider_slider_changed(value):
	settings_state.set("code_font_size", value)

func _on_VolMasterSlider_slider_changed(value):
	settings_state.set("master_volume", value)

func _on_VolMusicSlider_slider_changed(value):
	settings_state.set("music_volume", value)
