extends CharacterBody2D

@export var animations:AnimatedSprite2D

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animations.play("walk")

		# Flip the sprite depending on direction
		if direction > 0:
			animations.flip_h = false   # facing right
		else:
			animations.flip_h = true    # facing left
	else:
		animations.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func fetch_monologue():
	# this will fetch the loop and stage from Global then display that dialogue
	pass



