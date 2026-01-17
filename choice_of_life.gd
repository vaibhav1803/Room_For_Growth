extends Control

@export_file("*.tscn") var loop3_start_scene: String = "res://Main folder/Stage Controller/loop3_stage1.tscn"
@export_file("*.tscn") var bad_ending_scene: String = "res://Main folder/Stage Controller/bad_ending.tscn"

@onready var btn_good: Button = $HBoxContainer/ChoiceA     # your top button
@onready var btn_bad: Button =  $HBoxContainer/ChoiceB    # your bottom button


func _ready() -> void:
	if not btn_good.pressed.is_connected(_on_good_pressed):
		btn_good.pressed.connect(_on_good_pressed)

	if not btn_bad.pressed.is_connected(_on_bad_pressed):
		btn_bad.pressed.connect(_on_bad_pressed)


# Choice A (continue to Loop 3)
func _on_good_pressed() -> void:
	get_tree().change_scene_to_file(loop3_start_scene)


# Choice B (end game)
func _on_bad_pressed() -> void:
	get_tree().change_scene_to_file(bad_ending_scene)
