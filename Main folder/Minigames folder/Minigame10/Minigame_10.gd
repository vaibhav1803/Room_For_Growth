extends Node2D

var brick_layout_scene:PackedScene = preload("res://Main folder/Minigames folder/Minigame10/brick_layout.tscn")
@onready var score = $score

signal minigame_finished(success)

@export var win_score = 2000

func _ready():
	Minigame10Global.score = 0
	add_bricks()

func _process(_delta):
	if Minigame10Global.bricks_count == 0:
		Minigame10Global.ball_speed += 1
		add_bricks()
	print(Minigame10Global.bricks_count,"    ", Minigame10Global.ball_speed)
	$score.text = str(Minigame10Global.score)
	if Minigame10Global.score >= win_score:
		_handle_win()

func _on_dead_body_entered(body):
	if body.is_in_group("ball"):
		get_tree().call_deferred("reload_current_scene")
		

func add_bricks():
	var bricks = brick_layout_scene.instantiate()
	bricks.position = Vector2(0,0)
	add_child(bricks)
	Minigame10Global.bricks_count = 50

func _handle_win() -> void:
	score.text = "Task Completed!"
	minigame_finished.emit(true)
