extends Node2D

signal minigame_finished(success: bool)

@onready var label = $Label
@onready var player = $mini_player_6

func _ready():
	player.restart_level.connect(_on_restart_level)
	player.reached_goal.connect(_on_player_win)

func _on_restart_level():
	print("Restarting minigame state")
	_reset_level()

func _on_player_win():
	_handle_win()

func _handle_win():
	label.text = "Task Completed!"
	minigame_finished.emit(true)

func _reset_level():
	# Reset player position, enemies, timers, etc.
	get_tree().reload_current_scene()
