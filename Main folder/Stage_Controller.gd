extends Node

#Note: play teacher move animation when player is near her
# --- CONFIGURATION (Set these in the Inspector) ---

@export_group("Scene Flow")
@export var scene_key: String = ""
@export_file("*.tscn") var next_scene_path: String

@export_group("Step 1: Intro")
@export var start_event: String = "entry"
@export var corruption_start: int = 0

@export_group("Step 2: Minigame")
@export var use_minigame: bool = false

@export_group("Step 3: Popup")
@export var use_popup: bool = false

# Normal popup flow (single button popup)
@export var popup_event_key: String = ""     # monologue AFTER popup (optional)
@export var corruption_popup: int = 0

@export_group("Popup Choice Mode (ONLY for L3 Toddler Choice)")
@export var popup_is_choice: bool = false    # OFF for normal scenes
@export var choice_event_a: String = "rewrite_verses_bad"
@export var choice_event_b: String = "acceptance_good"
@export_file("*.tscn") var next_scene_a_path: String
@export_file("*.tscn") var next_scene_b_path: String

# --- INTERNAL REFERENCES ---
@onready var monologue_ui = $CanvasLayer/Monologue_Manager
@onready var minigame_ui = $Player/Minigame_Manager
@onready var popup_ui = $Popup_Manager
@onready var load_player = $load_player


# State Machine
enum State { PLAYING_INTRO, PLAYING_MINIGAME, WAITING_FOR_POPUP, PLAYING_OUTRO, FINISHED }
var current_state = State.PLAYING_INTRO

var _override_next_scene_path: String = ""
var _override_outro_event_key: String = ""


func _ready() -> void:
	if load_player:
		load_player.play()
	# 1) Hide other layers safely
	_set_minigame_visible(false)
	_set_popup_visible(false)

	if monologue_ui:
		monologue_ui.visible = true

	# 2) Connect monologue finished
	if monologue_ui:
		if not monologue_ui.dialogue_finished.is_connected(_on_monologue_finished):
			monologue_ui.dialogue_finished.connect(_on_monologue_finished)

	# 3) Connect popup signals
	if popup_ui:
		# Normal popup ("next_clicked")
		if popup_ui.has_signal("next_clicked"):
			if not popup_ui.next_clicked.is_connected(_on_popup_clicked):
				popup_ui.next_clicked.connect(_on_popup_clicked)

		# Choice popup ("choice_selected") ONLY used if popup_is_choice = true
		if popup_ui.has_signal("choice_selected"):
			if not popup_ui.choice_selected.is_connected(_on_choice_selected):
				popup_ui.choice_selected.connect(_on_choice_selected)

	# 4) Connect minigame finished
	if minigame_ui and minigame_ui.has_signal("minigame_finished"):
		if not minigame_ui.minigame_finished.is_connected(_on_minigame_finished):
			minigame_ui.minigame_finished.connect(_on_minigame_finished)

	# Start
	_start_intro()


func _start_intro() -> void:
	current_state = State.PLAYING_INTRO
	await get_tree().create_timer(0.5).timeout

	if monologue_ui:
		monologue_ui.start_monologue(scene_key, start_event, corruption_start)


func _on_monologue_finished() -> void:
	match current_state:
		State.PLAYING_INTRO:
			if use_minigame:
				_start_minigame()
			elif use_popup:
				_show_popup()
			else:
				_change_scene()

		State.PLAYING_OUTRO:
			_change_scene()


func _start_minigame() -> void:
	current_state = State.PLAYING_MINIGAME

	if monologue_ui:
		monologue_ui.visible = false

	_set_minigame_visible(true)

	if minigame_ui and minigame_ui.has_method("start_game"):
		minigame_ui.start_game()


func _on_minigame_finished(_success: bool = true) -> void:
	_set_minigame_visible(false)
	minigame_ui.queue_free()
	if use_popup:
		_show_popup()
	else:
		_start_outro()


func _show_popup() -> void:
	current_state = State.WAITING_FOR_POPUP

	if monologue_ui:
		monologue_ui.visible = false

	_set_popup_visible(true)

	# Optional: if your popup has a setup method, call it here
	# (e.g. show error text for L3 toddler)
	if popup_is_choice and popup_ui and popup_ui.has_method("show_choice"):
		# You can pass whatever your popup needs here:
		# example: popup_ui.show_choice(scene_key, "system_popup_error")
		popup_ui.show_choice(scene_key, "system_popup_error")


# Normal popup path (single "Next" button)
func _on_popup_clicked() -> void:
	if popup_is_choice:
		# Ignore normal popup clicks in choice mode
		return

	_set_popup_visible(false)

	if popup_event_key != "":
		_start_outro()
	else:
		_change_scene()


# Choice popup path (A/B)
func _on_choice_selected(choice_id: String) -> void:
	if not popup_is_choice:
		return

	_set_popup_visible(false)

	# Set overrides for THIS scene only
	if choice_id == "A":
		_override_outro_event_key = choice_event_a
		_override_next_scene_path = next_scene_a_path
	else:
		_override_outro_event_key = choice_event_b
		_override_next_scene_path = next_scene_b_path

	_start_outro()


func _start_outro() -> void:
	current_state = State.PLAYING_OUTRO

	if monologue_ui:
		monologue_ui.visible = true

		var event_to_play := popup_event_key
		if _override_outro_event_key != "":
			event_to_play = _override_outro_event_key

		monologue_ui.start_monologue(scene_key, event_to_play, corruption_popup)


func _change_scene() -> void:
	current_state = State.FINISHED
	load_player.play()
	var path_to_use := next_scene_path
	if _override_next_scene_path != "":
		path_to_use = _override_next_scene_path

	if path_to_use != "":
		load_player.play()
		get_tree().change_scene_to_file(path_to_use)
	else:
		print("StageController: End of Demo (No next scene set)")


# --- VISIBILITY HELPERS ---
func _set_minigame_visible(is_visible: bool) -> void:
	if not minigame_ui:
		return

	minigame_ui.visible = is_visible
	if minigame_ui.has_node("CanvasLayer"):
		minigame_ui.get_node("CanvasLayer").visible = is_visible


func _set_popup_visible(is_visible: bool) -> void:
	if not popup_ui:
		return

	popup_ui.visible = is_visible
	if popup_ui.has_node("CanvasLayer"):
		popup_ui.get_node("CanvasLayer").visible = is_visible



