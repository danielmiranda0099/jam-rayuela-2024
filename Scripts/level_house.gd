extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	disabled_collision()

func disabled_collision() -> void:
	%TimerCollision.disabled = true
