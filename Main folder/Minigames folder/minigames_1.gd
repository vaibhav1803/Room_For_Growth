extends Control

# This signal is REQUIRED for the StageController to work!
signal minigame_finished(success)

@onready var target_label: Label = $ColorRect/Label
@onready var timer: Timer = $Timer

@export var min_value: int = 0
@export var max_value: int = 99
@export var target_wins: int = 6   # How many you need to win
@export var feedback_delay_sec: float = 0.7

var _target: int = 0
var _input_buffer: String = ""
var _locked: bool = false
var _current_wins: int = 0         # Tracks your current streak

func _ready() -> void:
	randomize()
	timer.one_shot = true
	
	# Safety check: connect timer if not connected in editor
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
		
	_current_wins = 0
	_next_round()

func _unhandled_input(event: InputEvent) -> void:
	if _locked:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_submit()
			return

		if event.keycode == KEY_BACKSPACE:
			if _input_buffer.length() > 0:
				_input_buffer = _input_buffer.substr(0, _input_buffer.length() - 1)
			_update_label()
			return

		if event.keycode == KEY_ESCAPE:
			_input_buffer = ""
			_update_label()
			return

		var ch := event.as_text()
		if ch.length() == 1 and ch >= "0" and ch <= "9":
			_input_buffer += ch
			_update_label()
			return

func _next_round() -> void:
	_locked = false
	_input_buffer = ""
	_target = randi_range(min_value, max_value)
	_update_label()

func _update_label() -> void:
	var typed := _input_buffer if _input_buffer != "" else "..."
	
	# Display the Progress (e.g., [ 2 / 6 ])
	var text = "Type the Number: %d\n" % _target
	text += "Your Input: %s\n" % typed
	text += "--------------------------------\n"
	text += "Progress: %d / %d" % [_current_wins, target_wins]
	
	target_label.text = text

func _submit() -> void:
	if _input_buffer == "":
		return

	var guess := int(_input_buffer)
	
	if guess == _target:
		# CORRECT ANSWER
		_current_wins += 1
		
		if _current_wins >= target_wins:
			_handle_win()
		else:
			_show_feedback("Correct! (%d/%d)" % [_current_wins, target_wins], true)
			
	else:
		# WRONG ANSWER - RESET PROGRESS
		_current_wins = 0
		_show_feedback("Wrong! Progress Reset to 0.", false)

func _handle_win():
	_locked = true
	target_label.text = "ACCESS GRANTED\nSystem Bypassed."
	
	# Wait 1 second, then tell StageController we are done
	await get_tree().create_timer(1.0).timeout
	minigame_finished.emit(true) 

func _show_feedback(message: String, _correct: bool) -> void:
	_locked = true
	target_label.text = message
	timer.start(feedback_delay_sec)

func _on_timer_timeout() -> void:
	# Only start next round if we haven't won yet
	if _current_wins < target_wins:
		_next_round()
