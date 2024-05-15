extends Node


func change_scene(scene, is_clear=false) -> void:
	if is_clear:
		get_node("/root/Main/ContentScenes").free()

		var ContentScenes = Node2D.new()
		ContentScenes.set_name("ContentScenes")
		get_node("/root/Main").add_child(ContentScenes)

	get_node("/root/Main/ContentScenes").add_child(scene)
	print("Change scene")
