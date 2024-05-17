extends Node
class_name Load_JSON

static func load_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		print("File Doesn't Exist")
		return {}

	var data_file = FileAccess.open(path, FileAccess.READ)
	var data_parse = JSON.parse_string(data_file.get_as_text())

	if not data_parse is Dictionary:
		print("Error Reading File")
		return {}
	
	return data_parse