class_name LogosList extends Resource

@export var entries: Array[String] = []


func load_from_folder(folder_path: String) -> void:
	var dir := DirAccess.open(folder_path)
	entries.assign(dir.get_files())
