extends Node

var texts = ["Como bien saben han sido seleccionados por la organizacion ONE PIECE ", 
"ustedes han despertado poderes sobre humanos mas alla de la comprension",
"Esta su primera estapa ya prenderan que tendran que hacer en sus misiones basicas"
]

var has_text_typing_played: bool = false

func _process(_delta):
	if has_text_typing_played:
		return
		
	%Text.text = ""
	TEXT_TYPING_global.text_typing(texts, %Text, %Audio)

	has_text_typing_played = true
	
