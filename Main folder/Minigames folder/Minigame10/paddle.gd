extends CharacterBody2D


const SPEED = 400.0


func _physics_process(_delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.y > 0:
		velocity.y = 0
	move_and_slide()

