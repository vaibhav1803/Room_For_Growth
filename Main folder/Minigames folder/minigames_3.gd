extends Control

# --- REQUIRED: Signal for StageController ---
signal minigame_finished(success)

# Adjust these paths if your scene tree is different
@onready var grid: GridContainer = $VBoxContainer/GridContainer
@onready var status_label: Label = $VBoxContainer/Label

# We don't need Play Again/Quit buttons for the story mode
# @onready var play_again_button... (Removed)
# @onready var quit_button... (Removed)

var board := ["", "", "", "", "", "", "", "", ""]
var current_player := "X"
var game_over := false

const PLAYER := "X"
const COMPUTER := "O"

func _ready():
	# Connect grid buttons
	for i in range(grid.get_child_count()):
		var button := grid.get_child(i) as Button
		# Check to avoid connecting twice if you reload
		if not button.pressed.is_connected(_on_cell_pressed):
			button.pressed.connect(_on_cell_pressed.bind(i))

	status_label.text = "Your Turn (X)"

func _on_cell_pressed(index):
	if game_over or current_player != PLAYER or board[index] != "":
		return

	_make_move(index, PLAYER)

	if not game_over:
		# Small delay for AI thinking
		await get_tree().create_timer(0.4).timeout
		_computer_move()

func _make_move(index: int, player: String):
	board[index] = player
	var button := grid.get_child(index) as Button
	button.text = player

	# Check for Win
	if _check_win(player):
		_end_game(player) # Pass who won
		return

	# Check for Draw
	if not board.has(""):
		_end_game("Draw")
		return

	# Switch Turns
	current_player = COMPUTER if player == PLAYER else PLAYER
	status_label.text = "Computer's Turn" if current_player == COMPUTER else "Your Turn (X)"

func _computer_move():
	if game_over: return
	var index := _find_best_move()
	_make_move(index, COMPUTER)

func _find_best_move() -> int:
	# 1. Try to win
	for i in range(9):
		if board[i] == "":
			board[i] = COMPUTER
			if _check_win(COMPUTER):
				board[i] = ""
				return i
			board[i] = ""

	# 2. Block player
	for i in range(9):
		if board[i] == "":
			board[i] = PLAYER
			if _check_win(PLAYER):
				board[i] = ""
				return i
			board[i] = ""

	# 3. Random move
	var empty := []
	for i in range(9):
		if board[i] == "":
			empty.append(i)
	
	if empty.size() > 0: return empty.pick_random()
	return -1

func _check_win(player: String) -> bool:
	var wins = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
	for combo in wins:
		if board[combo[0]] == player and board[combo[1]] == player and board[combo[2]] == player:
			return true
	return false

# --- MODIFIED END GAME LOGIC ---
func _end_game(result: String):
	game_over = true
	
	# 1. Update Text for the Story
	if result == PLAYER:
		status_label.text = "You won! But the \n teacher is watching..."
	elif result == "Draw":
		status_label.text = "Draw. The teacher clears her throat."
	else:
		status_label.text = "Lost. The teacher slams the desk!"

	# 2. Wait 2 seconds so player sees the result
	await get_tree().create_timer(2.0).timeout
	
	# 3. Emit the signal to trigger the Popup
	# This tells StageController: "Hide the game, Show the Popup Manager"
	minigame_finished.emit(true)
