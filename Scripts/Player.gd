extends CharacterBody2D

@export var SPEED: int = 130

var is_move_on = true
var is_move_on_break_ladder = false

const pre_magic_effect = preload("res://components/effects/effect_magic.tscn")

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if is_move_on:
		self.velocity = Vector2.ZERO
		var direction = Input.get_vector("left", "right", "up", "down")

		if (direction.length()):
			self.velocity = direction * SPEED
			self.velocity.normalized()
			animationsPlayer()
		else:
			$Animation.stop()
			self.velocity = Vector2.ZERO
		
	if is_move_on_break_ladder:
		move_on_break_ladder()

	move_and_slide()


func animationsPlayer():
		if self.velocity.y < 0 and self.velocity.x == 0 :
			$Animation.animation = "up"
		
		if self.velocity.x > 0 and self.velocity.y == 0 :
			$Animation.animation = "right"

		if self.velocity.y > 0 and self.velocity.x == 0 :
			$Animation.animation = "down"
		
		if self.velocity.x < 0 and self.velocity.y == 0 :
			$Animation.animation = "left"
		
		if self.velocity.y < 0 and self.velocity.x > 0 :
			$Animation.animation = "up-right"

		if self.velocity.x > 0 and self.velocity.y > 0 :
			$Animation.animation = "right-down"

		if self.velocity.y > 0 and self.velocity.x < 0 :
			$Animation.animation = "down-left"
		
		if self.velocity.x < 0 and self.velocity.y < 0 :
			$Animation.animation = "left-up"

		$Animation.play()


func _on_area_area_entered(area:Area2D):
	if (area.has_meta("HandleFunction")):
		var handle_function = area.get_meta("HandleFunction")
		
		if(handle_function == "break_ladder"):
			is_move_on = false
			is_move_on_break_ladder = true

	if (area.get_parent().has_meta("MagicEffect")):
		MagicEffect(area)


func move_on_break_ladder() -> void:
	$Collision.disabled = true
	$Area/Collision.disabled = true

	var target = get_parent().get_node("BreakLadder/Marker").global_position

	self.z_index = 100
	$Animation.animation = "roll-right-down"

	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)

	tween.tween_property(self, "global_position", target, 1.5)

	tween.tween_callback(move_on_break_ladder_finish)

func move_on_break_ladder_finish():
	$Collision.disabled = false
	$Area/Collision.disabled = false
	self.z_index = 0

	is_move_on = true
	is_move_on_break_ladder = false


func MagicEffect(area) -> void:
	is_move_on = false
	self.velocity = Vector2.ZERO
	var magic_effect = pre_magic_effect.instantiate()

	add_child(magic_effect)

	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(magic_effect, "scale", Vector2(1.7, 1.7), 1);
	tween.tween_property(magic_effect, "scale", Vector2(0.1, 0.1), 1);
	area.get_parent().queue_free()

	await get_tree().create_timer(1).timeout

	var new_scene = load("res://Levels/cinematic_controller.tscn").instantiate()
	new_scene.path_data = "res://Cinematics/test.json"
	queue_free()
	MAIN_global.change_scene(new_scene, true)


	
