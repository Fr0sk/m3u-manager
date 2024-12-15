extends ColorRect


@export var entry: M3uEntry: 
	set(val):
		entry = val
		refresh_ui()

@export var is_odd := false
@export var odd_color: Color

@onready var name_label: Label = %NameLabel
@onready var group_label: Label = %GroupLabel
@onready var logo_text: LineEdit = %LogoText
@onready var group_text: LineEdit = %GroupText


func _on_group_button_pressed() -> void:
	pass # Replace with function body.


func refresh_ui() -> void:
	if is_odd: 
		color = odd_color
	
	if not entry:
		return
	
	name_label.text = entry.name
	group_label.text = entry.tvg_id
	group_label.modulate = Color.DARK_ORANGE if entry.is_tvg_id_sugested else Color.WHITE
	logo_text.text = entry.tvg_logo
	group_text.text = entry.group_title
	
