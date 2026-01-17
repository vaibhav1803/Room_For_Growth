extends Control

# StageController expects: minigame_finished(success: bool)
signal minigame_finished(success: bool)

@onready var grid: GridContainer = $Panel/VBoxContainer/GridContainer
@onready var label: Label = $Panel/VBoxContainer/Label

var current_number: int = 1
var numbers: Array[int] = []


func _ready() -> void:
	label.text = "Tap numbers in order"

	# Connect buttons ONCE (no disconnecting needed)
	for child in grid.get_children():
		var btn := child as Button
		if btn:
			if not btn.pressed.is_connected(_on_button_pressed.bind(btn)):
				btn.pressed.connect(_on_button_pressed.bind(btn))

	_setup_buttons()


func start_game() -> void:
	# Optional: StageController calls this if it exists
	_setup_buttons()


func _setup_buttons() -> void:
	# Reset game state
	current_number = 1
	label.text = "Next: %d" % current_number

	# Build and shuffle numbers
	numbers.clear()
	for i in range(1, 11):
		numbers.append(i)
	numbers.shuffle()

	# Assign shuffled numbers to buttons
	for i in range(grid.get_child_count()):
		if i >= numbers.size():
			break

		var btn := grid.get_child(i) as Button
		if not btn:
			continue

		var num := numbers[i]
		btn.text = str(num)
		btn.disabled = false
		btn.set_meta("num", num)


func _on_button_pressed(btn: Button) -> void:
	var num := int(btn.get_meta("num"))

	if num != current_number:
		return

	btn.disabled = true
	current_number += 1

	if current_number > 10:
		_handle_win()
	else:
		label.text = "Next: %d" % current_number


func _handle_win() -> void:
	label.text = "Task Completed!"
	minigame_finished.emit(true)


func _on_reload_pressed() -> void:
	# If you want reset-in-place instead of reloading the whole scene:
	_setup_buttons()
	# Or if you prefer full reload:
	# get_tree().reload_current_scene()
