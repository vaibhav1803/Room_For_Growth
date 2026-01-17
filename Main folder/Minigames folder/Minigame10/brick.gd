extends StaticBody2D



func _on_area_2d_body_entered(body):
	if body.is_in_group("ball"):
		Minigame10Global.bricks_count -= 1
		Minigame10Global.score += 50
		self.queue_free()
