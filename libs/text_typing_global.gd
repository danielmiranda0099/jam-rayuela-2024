extends Node

signal finish_typing_event
signal ui_accept_event

var is_resume_text: bool = false
var is_typing: bool = false
var is_finish_typing: bool = false

func text_typing(texts: Array, label: Label, audio: AudioStreamPlayer2D, audio_finish = null) -> void:
	for text in texts:
		is_typing = true

		for letter in text:
			label.text += letter
			audio.play()

			if is_resume_text:
				is_resume_text = false
				is_typing = false
				break
			
			await get_tree().create_timer(0.06).timeout

		label.text = text
		await get_tree().create_timer(0.3).timeout

		if (audio_finish):
			audio_finish.play()

		is_typing = false

		await ui_accept_event

		label.text = ""

		await get_tree().create_timer(0.5).timeout
	
	is_finish_typing = true
	print("finish")
	finish_typing_event.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		ui_accept_event.emit()
		
		if (is_typing):
			is_resume_text = true
