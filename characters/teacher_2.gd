extends Area2D

@onready var animation = $NPC4_loop2stage3
@onready var area_2d = $Area2D

func _ready():
	if area_2d:
		if not area_2d.body_entered.is_connected(_on_area_2d_body_entered):
			area_2d.body_entered.connect(_on_area_2d_body_entered)
		if not area_2d.body_exited.is_connected(_on_area_2d_body_exited):
			area_2d.body_exited.connect(_on_area_2d_body_exited)
	
	if animation:
		animation.play("idle")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if animation:
			animation.play("move")

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		if animation:
			animation.play("idle")
