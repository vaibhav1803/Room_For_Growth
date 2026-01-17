extends CharacterBody2D

@onready var toddler_animation:AnimatedSprite2D = $animation

func _physics_process(_delta):

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		toddler_animation.play("move")
	else:
		toddler_animation.play("idle")
		pass
