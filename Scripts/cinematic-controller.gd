extends Node

signal ui_accept_next
signal event_finish

var rate_progress: float
var progressText: float

var data: Dictionary = {} 
@export var path_data: String

# allows not execute an infinite loop when the scene is finished, while not declare history_scene
var played_scene: bool = false

var history_scene: Array = []

var is_next_scene: bool = true
var is_resume_text: bool = false
var is_typing: bool = false

func _ready():
	data = load_json_file(path_data)

func _process(_delta):
	if played_scene:
		return	

	for scene_name in data.keys():
		if (not history_scene.has(scene_name)) and is_next_scene:
			
			history_scene.append(scene_name)
			is_next_scene = false

			print(scene_name)
			var scene_data = data[scene_name]
			var scene_data_history: Array = []
			for key in scene_data.keys():
				if (not scene_data_history.has(key)):
					scene_data_history.append(key)
					if(key.contains("TEXT")):
						print(scene_data[key])
						text_typing_controller(scene_data[key])
					if(key.contains("GO")):
						var new_scene = load(scene_data[key]).instantiate()
						MAIN_global.change_scene(new_scene)
						queue_free()
					if(key.contains("WAIT")):
						await event_finish

			await event_finish
		

	played_scene = true
	
	# for item in data["SCENE"]:
	# 	print(item)
	# 	if not history_scene.has(item):
	# 		if(item.contains("TYPE") and $AnimationViewportContainer.visible == true):
	# 			$AnimationViewportContainer.visible = false
	# 			%Text.position = Vector2(-14, 35)
	# 		if(item.contains("TYPE") and data["SCENE"][item] == "cinematic" and $AnimationViewportContainer.visible == false):
	# 			$AnimationViewportContainer.visible = true
	# 			%Text.position = Vector2(-14, 147)

	# 		if(item.contains("ANIM")):
	# 			animation_controller(data["SCENE"][item])

	# 		if(item.contains("TEXT")):
	# 			text_typing_controller(data["SCENE"][item])

	# 		if(item.contains("EVENT")):
	# 			await event_finish

			
		
	# 	history_scene.append(item)
	

func animation_controller(data_animation):
	var animation = get_node("AnimationViewportContainer/AnimationSubViewport/Cinematic/"+data_animation[0]) as AnimationPlayer
	animation.play(data_animation[1])
	await animation.animation_finished
	event_finish.emit()

func text_typing_controller(texts):
	%Text.text = ""

	for text in texts:
		is_typing = true
		for letter in text:
			%Text.text += letter
			$Audio.play()
			if is_resume_text:
				is_resume_text = false
				is_typing = false
				break
			await get_tree().create_timer(0.06).timeout
		
		%Text.text = text
		await get_tree().create_timer(0.3).timeout	
		$AudioFinish.play()
		is_typing = false
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

		is_next_scene = true
		
		if(is_typing):
			is_resume_text = true
		
