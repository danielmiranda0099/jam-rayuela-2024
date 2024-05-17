extends Area2D

var is_in_area: bool = false


func _ready():
	pass

func _on_area_entered(area:Area2D):
	if area.get_parent() is Player:
		$Icon.visible = true
		is_in_area = true
		
func _on_area_exited(area:Area2D):
	if area.get_parent() is Player:
		$Icon.visible = false
		is_in_area = false
		$"../WindowTextEvent".visible = false
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_in_area:
			$"../WindowTextEvent".visible = true
