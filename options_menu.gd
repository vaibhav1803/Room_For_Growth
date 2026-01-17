extends Control

func _ready():
	# Set slider value to current master volume
	var master_bus_index = AudioServer.get_bus_index("Master")
	var current_db = AudioServer.get_bus_volume_db(master_bus_index)
	# Convert db to linear (0-1) for slider
	$VBoxContainer/VolumeSlider.value = db_to_linear(current_db)

func _on_volume_slider_value_changed(value):
	var master_bus_index = AudioServer.get_bus_index("Master")
	# Convert linear (0-1) to db
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
