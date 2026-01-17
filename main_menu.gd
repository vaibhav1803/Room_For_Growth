extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Main folder/loops folder/loop1/loop1_stage1.tscn")
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
