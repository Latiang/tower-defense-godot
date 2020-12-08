extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_sound_settings(settings_state):
	var master_volume = linear2db(settings_state.get("master_volume")/100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
	var music_volume = linear2db(settings_state.get("music_volume")/100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	$MusicPlayer.stream_paused = (settings_state.get("music_volume") == 0)
	
func start_music():
	$MusicPlayer.play()
	
func connect_button_sound_signals():
	descend_for_buttons(get_parent().get_node("LevelManager/GUI"))
	descend_for_buttons(get_parent().get_node("MainMenu"))

func descend_for_buttons(node):
	for child in node.get_children():
		if child is Button or child is LevelSelectNode:
			child.connect("pressed", self, "play_button_sound")
		else:
			descend_for_buttons(child)
	

func play_button_sound(placeholder = 0):
	$ButtonSoundPlayer.play()
