extends Control

# --- REQUIRED SIGNAL ---
signal minigame_finished(success) 

@onready var result_label = $Panel1/Panel2/VBoxContainer/ResultLabel
@onready var score_label = $Panel1/Panel2/VBoxContainer/ScoreLabel
@onready var rock_button = $Panel1/Panel2/VBoxContainer/HBoxContainer/RockButton
@onready var paper_button = $Panel1/Panel2/VBoxContainer/HBoxContainer/PaperButton
@onready var scissors_button = $Panel1/Panel2/VBoxContainer/HBoxContainer/ScissorsButton

var choices = ["Rock", "Paper", "Scissors"]

var player_score := 0
var computer_score := 0
var draw_score := 0
var round_count := 0

const MAX_ROUNDS := 5 # Reduced to 5 for faster gameplay testing

func _ready():
	# Connect buttons
	rock_button.pressed.connect(func(): play_game("Rock"))
	paper_button.pressed.connect(func(): play_game("Paper"))
	scissors_button.pressed.connect(func(): play_game("Scissors"))
	update_score_label()

func play_game(player_choice: String):
	if round_count >= MAX_ROUNDS:
		return

	round_count += 1

	var computer_choice = choices.pick_random()
	var result = get_result(player_choice, computer_choice)

	update_score(result)

	result_label.text = (
		"Round %d / %d\n\n🧑 You: %s\n🤖 Computer: %s\n\n%s"
		% [round_count, MAX_ROUNDS, player_choice, computer_choice, result]
	)

	check_game_end()

func get_result(player: String, computer: String) -> String:
	if player == computer:
		return "Draw"

	if (
		(player == "Rock" and computer == "Scissors") or
		(player == "Paper" and computer == "Rock") or
		(player == "Scissors" and computer == "Paper")
	):
		return "Win"
	else:
		return "Lose"

func update_score(result: String) -> void:
	match result:
		"Win":
			player_score += 1
		"Lose":
			computer_score += 1
		"Draw":
			draw_score += 1

	update_score_label()

func update_score_label():
	score_label.text = (
		"Score — \n You: %d \n Computer: %d \n Draws: %d\n ---"
		% [player_score, computer_score, draw_score]
	)

# 🏁 End-game logic
func check_game_end():
	if round_count < MAX_ROUNDS:
		return

	disable_buttons()

	var final_message = get_final_message()
	result_label.text = final_message

	close_game_after_delay()

func get_final_message() -> String:
	if player_score > computer_score:
		return "🎉 You Won the Match!\nProceeding..."
	elif player_score < computer_score:
		return "😢 Match Lost.\nProceeding..."
	else:
		return "🤝 It's a Draw!\nProceeding..."

func disable_buttons():
	rock_button.disabled = true
	paper_button.disabled = true
	scissors_button.disabled = true

func close_game_after_delay():
	# Wait for player to read result
	await get_tree().create_timer(1.5).timeout
	
	# Determine success
	var did_win = player_score >= computer_score
	
	# DO NOT QUIT. EMIT SIGNAL INSTEAD.
	# This tells StageController to hide the game and show the popup.
	minigame_finished.emit(did_win)
