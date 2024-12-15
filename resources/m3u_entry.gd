class_name M3uEntry extends Resource

## Duration of the media, in seconds
@export var duration: int = 0

## Name of the stream, to appear in players
@export var name: String = ""

## Stream URL
@export var location: String = ""

## TV Guide Group 
@export var tvg_id: String = ""

## Flag to color the text when the ID is sugested and not parsed. Internal Use
@export var is_tvg_id_sugested := false

## TV Channel Logo location
@export var tvg_logo: String = ""

## TV Channel Group/Category
@export var group_title: String = ""

static var logo_prefix := "https://raw.githubusercontent.com/Fr0sk/epg-tv-portuguesa/refs/heads/master/logos/"


func load_from_text(extinf_line: String, stream_location: String) -> M3uEntry:
	if not extinf_line.begins_with("#EXTINF"):
		printerr("Failed to parse EXTINF line")
		return self
	
	name = extinf_line.substr(extinf_line.rfind(",") + 1)
	location = stream_location
	
	var details := extinf_line.substr("#EXTINF:".length(), extinf_line.rfind(",") - "#EXTINF:".length())
	
	duration = int(details.substr(0, details.find(" ")))
	
	tvg_id = _parse_param(details, "tvg-id")
	tvg_logo = _parse_param(details, "tvg-logo")
	group_title = _parse_param(details, "group-title")
	
	return self


func as_string() -> String:
	var str := "#EXTINF:" + str(duration)
	
	if not tvg_id.is_empty():
		str += " tvg-id=\"" + tvg_id + "\""
	if not tvg_logo.is_empty():
		str += " tvg-logo=\"" + logo_prefix + tvg_logo.replace(" ", "%20") + "\""
	if not group_title.is_empty():
		str += " group-title=\"" + group_title + "\""
	
	str += "," + name + "\n" + location
	
	return str


func _parse_param(text: String, key: String) -> String:
	var param := ""
	
	if text.contains(key):
		param = text.substr(text.find(key) + key.length() + 2) # Add 2 to account for ="
		param = param.substr(0, param.find("\""))
	
	return param
