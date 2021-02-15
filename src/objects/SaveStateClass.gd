
var raw_json = {}
var level_count = 0
var file = File.new()

enum LEVEL_STATUS {LOCKED, UNLOCKED, STARTED, COMPLETED}

func _init():
	reset_save()
	load_from_file()
		
# Setup initial state
func reset_save():
	load_from_file("initial_save")
	
func load_from_file(save_name = "save1"):
	var filename = "saves/%s.json" % save_name
	if file.file_exists(filename):
		print("[Save State] Loading save '%s' from file" % save_name)
		file.open(filename, File.READ)
		var text = file.get_as_text()
		raw_json = parse_json(text)
		level_count = len(raw_json["levels"])
		file.close()
	else:
		print("[Save State] No save file found, using initial save")
	
func save_to_file(save_name = "save1"):
	var filename = "saves/%s.json" % save_name
	print("[Save State] Saving save to file")
	file.open(filename, File.WRITE)
	file.store_line(to_json(raw_json))
	file.close()

# Save a level state
func save_level_data(level, level_id, status = LEVEL_STATUS.STARTED):
	var turret_codes = []
	turret_codes.resize(level.count_turrets())
	# Count turrets
	for child in level.get_children():
		if child.is_in_group("Turret"):
			turret_codes[child.id] = child.get_code_source()
	var updated = raw_json["levels"][level_id]
	updated["status"] = max(status, updated["status"])
	updated["turret_code"] = turret_codes
	#raw_json["levels"][level_name] = {"status": status, "turret_code" : turret_codes}
	
func load_level_data(level, level_id):
	for child in level.get_children():
		if child.is_in_group("Turret"):
			var code_text = raw_json["levels"][level_id]["turret_code"][child.id]
			child.update_source(code_text)
	
func unlock_level(level_id):
	raw_json["levels"][level_id]["status"] = LEVEL_STATUS.UNLOCKED
	save_to_file()
	
# Used for the main menu
func get_level_states():
	return raw_json["levels"]
	
func get_tutorial_popups(level_id):
	var popups = []
	if raw_json["levels"][level_id].has("tutorial_popups"):
		for popup in raw_json["levels"][level_id]["tutorial_popups"]:
			if len(popup) != 3:
				print("[Save State] Tutorial Popup for Level %d is malformed" % level_id)
			popups.append([Vector2(popup[0], popup[1]), popup[2]])
	return popups
	
func get_level_data(level_id):
	return raw_json["levels"][level_id]
