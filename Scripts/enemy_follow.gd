extends CharacterBody2D


var SPEED = 150

@export var target: Node2D

@onready var navigation_agent: NavigationAgent2D = $Navigation

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	if( self.position.x+10 > target.position.x ):
		$Sprite.flip_h = false
	
	if( self.position.x-10 > target.position.x ):
		$Sprite.flip_h = true

	var next_path_position: Vector2 = (navigation_agent.get_next_path_position() - global_position).normalized()

	
	self.velocity = velocity.lerp(next_path_position * SPEED, delta)

	move_and_slide() 

func make_path() -> void:
	navigation_agent.target_position = target.global_position

func _on_timer_timeout():
	make_path()


func _on_area_2d_area_entered(area:Area2D):
	if (area.has_meta("PowerUpEnemyUpSpeed")):
		SPEED = area.get_meta("PowerUpEnemyUpSpeed")
		self.scale = Vector2(1.2, 1.2)
