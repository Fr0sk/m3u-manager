class_name EpgList extends Resource

@export var entries: Array[EpgEntry] = []


func load_from_file(file_path: String) -> void:
	var file := FileAccess.open(file_path, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var line := file.get_line()
		
		if line.contains("channel id"):
			var id := line.substr(line.find("\"") + 1)
			id = id.substr(0, id.find("\""))
			
			var entry := EpgEntry.new()
			entry.channel_id = id
			
			entries.append(entry)
