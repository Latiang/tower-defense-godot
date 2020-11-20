extends Control

signal close_settings_menu()

func _ready():
	pass # Replace with function body.

func _on_BackButton_pressed():
	emit_signal("close_settings_menu")

func _on_VolMusicSlider_slider_changed(value):
	pass # Replace with function body.


func _on_CodeTextSlider_slider_changed(value):
	pass # Replace with function body.


func _on_TooltipsCheckbox_toggled(state):
	pass # Replace with function body.
