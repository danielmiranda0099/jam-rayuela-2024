extends Node

var history_scene: Array = []

var is_next_scene: bool = true

func typewriter(data: Dictionary, animationViewportContainer, textLabel, audio, audioFinish=null):
	for scene_name in data.keys():
		if (not history_scene.has(scene_name)) and is_next_scene:
			history_scene.append(scene_name)
			is_next_scene = false

			print(scene_name)
			var scene_data = data[scene_name]
			var scene_data_history: Array = []
			for key in scene_data.keys():
				# TODO intentar refact el salvaguarda
				if (not scene_data_history.has(key)):
					scene_data_history.append(key)

					if(key.contains("TYPE") and scene_data[key] == "cinematic" and animationViewportContainer.visible == false):
						animationViewportContainer.visible = true
						textLabel.position = Vector2(-14, 147)
						textLabel.set("theme_override_font_sizes/font_size", 10)
					if(key.contains("TYPE") and scene_data[key] == "text" and animationViewportContainer.visible == true):
						animationViewportContainer.visible = false
						textLabel.position = Vector2(-14, 35)
						textLabel.set("theme_override_font_sizes/font_size", 14)
	
					if(key.contains("TEXT")):
						print(scene_data[key])
						textLabel.text = ""
						TEXT_TYPING_global.text_typing(scene_data[key], textLabel, audio ,audioFinish,)
					if(key.contains("GO")):
						var new_scene = load(scene_data[key]).instantiate()
						MAIN_global.change_scene(new_scene)
						queue_free()
					if(key.contains("WAIT")):
						await TEXT_TYPING_global.finish_typing_event

			await TEXT_TYPING_global.finish_typing_event
	
# func animation_controller(data_animation):
# 	var animation = get_node("AnimationViewportContainer/AnimationSubViewport/Cinematic/"+data_animation[0]) as AnimationPlayer
# 	animation.play(data_animation[1])
# 	await animation.animation_finished
# 	# TEXT_TYPING_global.finish_typing_event.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		is_next_scene = true
