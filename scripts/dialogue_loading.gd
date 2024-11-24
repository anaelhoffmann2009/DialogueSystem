extends Node
class_name DialogueLoading

func load_json_file(json_file: String):
	if FileAccess.file_exists(json_file):
		var file = FileAccess.open(json_file, FileAccess.READ)
		var parsed_data = JSON.parse_string(file.get_as_text())
		
		if parsed_data:
			return parsed_data
		else:
			printerr("Failed to load JSON file")
