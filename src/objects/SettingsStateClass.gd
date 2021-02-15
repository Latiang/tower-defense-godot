extends Node

var raw_json = {}
var file = File.new()

func _init():
	load_from_file()
		
func load_from_file():
	var filename = "user://settings.json"
	if file.file_exists(filename):
		print("[Settings State] Loading settings from file")
		file.open(filename, File.READ)
		var text = file.get_as_text()
		raw_json = parse_json(text)
		file.close()
	else:
		print("[Settings State] No settings.json file found, creating new")
		file.open("res://assets/initial_settings.json", File.READ)
		var text = file.get_as_text()
		raw_json = parse_json(text)
		file.close()
	
func save_to_file():
	var filename = "user://settings.json"
	print("[Settings State] Saving settings to file")
	file.open(filename, File.WRITE)
	file.store_line(to_json(raw_json))
	file.close()
	
func set(name, value):
	raw_json[name] = value
	
func get(name):
	return raw_json[name]
