extends Node

@onready var type_writer_controller = preload("res://libs/text_media_typewriter_controller.tscn").instantiate()

var data: Dictionary = {} 
@export var path_data: String

# allows not execute an infinite loop when the scene is finished, while not declare history_scene
var played_scene: bool = false
var typewriter

func _ready():
	data = Load_JSON.load_json_file(path_data)
	

func _process(_delta):
	if played_scene:
		return	

	MAIN_global.add_child(type_writer_controller)
	type_writer_controller.typewriter(data, %AnimationViewportContainer, %Text, %Audio, %AudioFinish)

	played_scene = true

