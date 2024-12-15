extends Control

enum FileType {M3U, GUIDE}

const TableRow := preload("res://ui/components/table_row.tscn")

var last_file_requested := FileType.M3U

@onready var folder_dialog: FileDialog = $FolderDialog
@onready var file_dialog: FileDialog = $FileDialog
@onready var file_save_dialog: FileDialog = $FileSaveDialog
@onready var table_entries: VBoxContainer = %TableEntries
@onready var m3u_file_path: LineEdit = %M3uFilePath
@onready var guide_file_path: LineEdit = %GuideFilePath
@onready var logos_file_path: LineEdit = %LogosFilePath


func _on_file_dialog_file_selected(path: String) -> void:
	match last_file_requested:
		FileType.M3U:
			m3u_file_path.text = path
		FileType.GUIDE:
			guide_file_path.text = path


func _on_folder_dialog_file_selected(path: String) -> void:
	pass # Replace with function body.


func _on_load_m3u_button_pressed() -> void:
	last_file_requested = FileType.M3U
	file_dialog.popup()


func _on_load_guide_button_pressed() -> void:
	last_file_requested = FileType.GUIDE
	file_dialog.popup()


func _on_parse_button_pressed() -> void:
	ListManager.clear()
	for child in table_entries.get_children():
		child.queue_free()
		
	if guide_file_path.text.is_empty() or m3u_file_path.text.is_empty():
		return
	
	ListManager.m3u_list.load_from_file(m3u_file_path.text)
	ListManager.epg_list.load_from_file(guide_file_path.text)
	ListManager.logos_list.load_from_folder(logos_file_path.text)
	
	var is_odd := true
	for entry in ListManager.m3u_list.entries:
		var child := TableRow.instantiate()
		table_entries.add_child(child)
		
		child.is_odd = is_odd
		is_odd = not is_odd
		child.entry = entry


func _on_tvg_id_button_pressed() -> void:
	ListManager.sugest_group_matches()
	get_tree().call_group("table_row", "refresh_ui")


func _on_logos_button_pressed() -> void:
	ListManager.sugest_logos()
	get_tree().call_group("table_row", "refresh_ui")


func _on_group_button_pressed() -> void:
	ListManager.sugest_channel_groups()
	get_tree().call_group("table_row", "refresh_ui")


func _on_export_button_pressed() -> void:
	file_save_dialog.popup()


func _on_file_save_dialog_file_selected(path: String) -> void:
	ListManager.m3u_list.save_to_file(path)
