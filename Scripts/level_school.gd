extends Node

var texts = ["Como bien saben han sido seleccionados por la organizacion ONE PIECE ", 
"ustedes han despertado poderes sobre humanos mas alla de la comprension",
"Esta su primera estapa ya prenderan que tendran que hacer en sus misiones basicas"
]

var has_text_typing_played: bool = false

func _ready():
	%Player.is_movement = false

func _process(_delta):
	if TEXT_TYPING_global.is_finish_typing and not %Player.is_movement:
		%TextWindow.visible = false

		%Player.is_movement = true


	if has_text_typing_played:
		return

		
	%Text.text = ""
	TEXT_TYPING_global.text_typing(texts, %Text, %Audio)
	
	
	has_text_typing_played = true