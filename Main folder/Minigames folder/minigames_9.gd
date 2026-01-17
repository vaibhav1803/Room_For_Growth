extends Control

@onready var grid: GridContainer = $GridContainer
@onready var result_label: Label = $VBoxContainer/ResultLabel
@onready var miss_label: Label = $VBoxContainer/MissLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var mole_timer: Timer = $MoleTimer

var buttons: Array[Button] = []
var active_index: int = -1

var score: int = 0
var misses: int = 0
var ended: bool = false

const MAX_SCORE := 20
const MAX_MISSES := 5

signal minigame_finished(success: bool)


func _ready() -> void:
	randomize()

	# Collect buttons and connect ONCE
	buttons.clear()
	for child in grid.get_children():
		var btn := child as Button
		if btn:
			buttons.append(btn)
			if not btn.pressed.is_connected(_on_button_pressed.bind(btn)):
				btn.pressed.connect(_on_button_pressed.bind(btn))

	if not mole_timer.timeout.is_connected(spawn_mole):
		mole_timer.timeout.connect(spawn_mole)

	start_game()


# StageController calls this (because it checks has_method("start_game"))
func start_game() -> void:
	# Reset state
	ended = false
	score = 0
	misses = 0
	active_index = -1

	# Reset UI
	result_label.text = ""
	update_ui()

	# Reset buttons
	for b in buttons:
		b.disabled = false
		b.modulate = Color.DIM_GRAY

	# Start loop
	mole_timer.start()
	spawn_mole()


func spawn_mole() -> void:
	if ended:
		return

	# Missed previous mole
	if active_index != -1:
		misses += 1
		update_ui()
		if misses >= MAX_MISSES:
			end_game(false)
			return

	# Reset all buttons
	for b in buttons:
		b.modulate = Color.DIM_GRAY

	# Pick random mole
	active_index = randi() % buttons.size()
	buttons[active_index].modulate = Color.RED


func _on_button_pressed(button: Button) -> void:
	buttons[active_index].modulate = Color.GREEN
	if ended:
		return

	var index := buttons.find(button)

	if index == active_index:
		score += 1
		active_index = -1
		update_ui()

		if score >= MAX_SCORE:
			end_game(true)
	else:
		misses += 1
		update_ui()
		if misses >= MAX_MISSES:
			end_game(false)


func update_ui() -> void:
	score_label.text = "Score: %d" % score
	miss_label.text = "Misses: %d / %d" % [misses, MAX_MISSES]


func end_game(won: bool) -> void:
	if ended:
		return
	ended = true

	mole_timer.stop()
	active_index = -1

	for b in buttons:
		b.disabled = true
		b.modulate = Color.DIM_GRAY

	if won:
		result_label.text = "🎉 Task Completed"
		minigame_finished.emit(true)   # ✅ StageController proceeds
	else:
		result_label.text = "💀 Task Lost"
		minigame_finished.emit(false)  # ✅ StageController can still proceed if you want
