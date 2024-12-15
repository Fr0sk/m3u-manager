extends Node

var m3u_list := M3uList.new()
var epg_list := EpgList.new()
var logos_list := LogosList.new()


func clear() -> void:
	m3u_list.entries.clear()
	epg_list.entries.clear()
	logos_list.entries.clear()


func sugest_group_matches() -> void:
	for m3u in m3u_list.entries:
		if not m3u.tvg_id.is_empty():
			continue
		
		var m3u_words := m3u.name.split(" ")
		var matches := 0
		var best_epg: EpgEntry
		
		for epg in epg_list.entries:
			var epg_matches := 0
			
			for m3u_word in m3u_words:
				if epg.channel_id.containsn(m3u_word):
					epg_matches += 1
			
			if epg_matches > matches:
				matches = epg_matches
				best_epg = epg
		
		if best_epg:
			m3u.tvg_id = best_epg.channel_id
			m3u.is_tvg_id_sugested = true


func sugest_channel_groups() -> void:
	for m3u in m3u_list.entries:
		if not m3u.group_title.is_empty():
			continue
	
		if contains_expressions(m3u.name, ["spor", "benfica", "bola", "fuel"]):
			m3u.group_title = "Desporto"
		elif contains_expressions(m3u.name, ["rtp", "sic", "tvi"]):
			m3u.group_title = "Generalistas"


func sugest_logos() -> void:
	for m3u in m3u_list.entries:
		if not m3u.tvg_logo.is_empty():
			continue
		
		var m3u_words := m3u.name.split(" ")
		var matches := 0
		var best_logo: String
		
		for logo in logos_list.entries:
			var logo_matches := 0
			
			for m3u_word in m3u_words:
				if contains_expressions(m3u_word, ["pt, hd, 4k fhd"]):
					continue
				
				if logo.containsn(m3u_word):
					logo_matches += 1
			
			if logo_matches > matches:
				matches = logo_matches
				best_logo = logo
		
		if best_logo:
			m3u.tvg_logo = best_logo


func contains_expressions(text: String, expressions: Array[String]) -> bool:
	for exp in expressions:
		if text.containsn(exp):
			return true
	return false
