class_name M3uList extends Resource

# https://ha.fr0sk.duckdns.org/local/content/list_pt.m3u
@export var entries: Array[M3uEntry] = []


func load_from_file(file_path: String) -> void:
	var file := FileAccess.open(file_path, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var line := file.get_line()
		
		if line.begins_with("#EXTM3U"):
			continue
		elif line.begins_with("#EXTINF"):
			var entry := M3uEntry.new().load_from_text(line, file.get_line())
			entries.append(entry)


func save_to_file(file_path: String) -> void:
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	
	file.store_line("#EXTM3U")
	for entry in entries:
		file.store_line(entry.as_string())
