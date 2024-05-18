extends Area2D

var is_in_area: bool = false

var data = [
	"Los OTROS no son de esta dimension por lo cual el armamento convencional no es eficiente",
	"Tienen capacidades regenerativas, fisicas y psiquicas",
	"La unica manera eficiente de afectarlos es atacando su 'ALMA"
]

var label: Label
var audio: AudioStreamPlayer2D

var is_text_typing_played: bool = false
var is_active_window_text_event: bool = false

func _ready():
	TEXT_TYPING_global.finish_typing_event.connect(on_text_typing_global_finish_typing)
	label = $"../WindowTextEvent/Text"
	audio = $"../WindowTextEvent/Audio"

func _process(_delta):
	if is_text_typing_played or !is_active_window_text_event:
		return

	TEXT_TYPING_global.text_typing(data, label, audio)

	is_text_typing_played = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_in_area:
			$"../WindowTextEvent".visible = true
			is_active_window_text_event = true
			($"../Player" as Player).on_movement.emit(false)

func _on_area_entered(area:Area2D):
	if area.get_parent() is Player:
		$Icon.visible = true
		is_in_area = true
		
func _on_area_exited(area:Area2D):
	if area.get_parent() is Player:
		$Icon.visible = false
		is_in_area = false
		$"../WindowTextEvent".visible = false
		is_active_window_text_event = false
		is_text_typing_played = false
		label.text = ""

func on_text_typing_global_finish_typing() -> void:
	$"../WindowTextEvent".visible = false
	($"../Player" as Player).on_movement.emit(true)
