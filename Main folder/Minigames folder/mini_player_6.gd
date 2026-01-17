extends CharacterBody2D

@export var speed := 400.0
@export var acceleration := 2000.0
@export var friction := 1800.0

signal restart_level
signal reached_goal

func _physics_process(delta):
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

func _on_area_2d_area_entered(area):
	if area.is_in_group("death"):
		emit_signal("restart_level")
	elif area.is_in_group("maze_win_area"):
		print("won")
		emit_signal("reached_goal")
