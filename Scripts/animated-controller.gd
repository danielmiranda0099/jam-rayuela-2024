extends Control

var rate_progress: float
var progressText: float

var data: Dictionary = {} 
var path_data = "res://Cinematics/open.json"

var played_scene: bool = false

func _ready():
	data = load_json_file(path_data)

	$Text.visible_ratio = 0

func _process(_delta):
	if not played_scene:
		for item in data["SCENE"]:
			print( data["SCENE"][item])
			if(item == "ANIM"):
				animation_controller(data["SCENE"][item])
			if(item == "TEXT"):
				text_typing_controller(data["SCENE"][item])
		played_scene = true

func animation_controller(data_animation):
	var animation = get_node(data_animation[0])
	animation.play(data_animation[1])

func text_typing_controller(texts):

	for text in texts:
		$Timer.autostart = true
		$Timer.start()
		
		$Text.text = text
		rate_progress = (1.0/$Text.text.length())
		progressText = rate_progress


func _on_timer_timeout():
	if progressText > 1: return

	$Text.visible_ratio = progressText
	progressText += rate_progress

func load_json_file(path: String):
	if not FileAccess.file_exists(path):
		print("File Doesn't Exist")
		return {}

	var data_file = FileAccess.open(path, FileAccess.READ)
	var data_parse = JSON.parse_string(data_file.get_as_text())

	if not data_parse is Dictionary:
		print("Error Reading File")
		return {}
	
	return data_parse



