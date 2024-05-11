extends Node

signal ui_accept_next
signal event_finish

var rate_progress: float
var progressText: float

var data: Dictionary = {} 
var path_data = "res://Cinematics/open.json"

var played_scene: bool = false

var history_scene: Array = []

func _ready():
	data = load_json_file(path_data)

func _process(_delta):
	if played_scene:
		return

	for item in data["SCENE"]:
		print(item)
		if not history_scene.has(item):
			if(item.contains("TYPE") and $AnimationViewportContainer.visible == true):
				$AnimationViewportContainer.visible = false
				%Text.position = Vector2(-14, 35)
			if(item.contains("TYPE") and data["SCENE"][item] == "cinematic" and $AnimationViewportContainer.visible == false):
				$AnimationViewportContainer.visible = true
				%Text.position = Vector2(-14, 147)

			if(item.contains("ANIM")):
				animation_controller(data["SCENE"][item])

			if(item.contains("TEXT")):
				text_typing_controller(data["SCENE"][item])

			if(item.contains("EVENT")):
				await event_finish

			
		
		history_scene.append(item)
	played_scene = true

func animation_controller(data_animation):
	var animation = get_node("AnimationViewportContainer/AnimationSubViewport/Cinematic/"+data_animation[0]) as AnimationPlayer
	animation.play(data_animation[1])
	await animation.animation_finished
	event_finish.emit()

func text_typing_controller(texts):
	for text in texts:
		for letter in text:
			%Text.text += letter
			# await get_tree().create_timer(0.05).timeout
			await get_tree().create_timer(0.01).timeout
		
		await ui_accept_next
		%Text.text = ""
		await get_tree().create_timer(0.5).timeout
	event_finish.emit()

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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		ui_accept_next.emit()
