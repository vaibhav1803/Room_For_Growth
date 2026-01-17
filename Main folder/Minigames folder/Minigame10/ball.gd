extends CharacterBody2D
class_name Ball


func _ready():
	velocity = Vector2(0,1) * Minigame10Global.ball_speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta * Minigame10Global.ball_speed)
	if collision:
		velocity = velocity.bounce(collision.get_normal())

