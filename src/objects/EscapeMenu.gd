extends PanelContainer

signal resume()
signal restart()
signal settings()
signal exit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_ResumeButton_pressed():
	emit_signal("resume")


func _on_RestartButton_pressed():
	emit_signal("restart")


func _on_SettingsButton_pressed():
	emit_signal("settings")


func _on_ExitButton_pressed():
	emit_signal("exit")
