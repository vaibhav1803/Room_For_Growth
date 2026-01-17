extends Control

signal dialogue_finished
signal specific_sequence_ended(sequence_id)

@onready var text_box: RichTextLabel = $Background/TextBox
@onready var background: ColorRect = $Background
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# State Variables
var current_queue: Array = []
var current_index: int = 0
var is_typing: bool = false
var corruption_level: int = 0
var current_loop_anim: String = "loop1"


func _ready():
	visible = false

	# ✅ Make sure the sprite is always visible + drawn correctly
	if animated_sprite_2d:
		animated_sprite_2d.visible = true
		animated_sprite_2d.z_index = 1

	# ✅ Put background under the sprite
	if background:
		background.z_index = 0

	# ✅ Put text above everything
	if text_box:
		text_box.z_index = 2


func _input(event):
	if event.is_action_pressed("ui_accept") and visible:
		if is_typing:
			text_box.visible_ratio = 1.0
			is_typing = false
		else:
			_show_next_line()


# --- MAIN FUNCTION ---
func start_monologue(scene_key: String, event_key: String, corruption: int = 0) -> void:
	visible = true
	corruption_level = corruption

	# ✅ decide correct UI skin
	_set_loop_animation(scene_key)

	# ✅ Safety check
	if MonologueData.loops.has(scene_key) and MonologueData.loops[scene_key].has(event_key):
		current_queue = MonologueData.loops[scene_key][event_key].duplicate()
		current_index = 0
		_apply_visual_style()
		_show_next_line()
	else:
		print("❌ ERROR: Key not found in MonologueData:", scene_key, "->", event_key)
		_end_dialogue()


# ✅ Choose loop animation based on scene key
func _set_loop_animation(scene_key: String) -> void:
	if scene_key.begins_with("L3_"):
		current_loop_anim = "loop3"
	elif scene_key.begins_with("L2_"):
		current_loop_anim = "loop2"
	else:
		current_loop_anim = "loop1"

	if animated_sprite_2d and animated_sprite_2d.sprite_frames:
		if animated_sprite_2d.sprite_frames.has_animation(current_loop_anim):
			animated_sprite_2d.play(current_loop_anim)

			# ✅ Force it visible ALWAYS
			animated_sprite_2d.visible = true
			print("✅ UI Skin Animation Playing:", current_loop_anim)
		else:
			print("⚠ Missing animation in AnimatedSprite2D:", current_loop_anim)


func _show_next_line() -> void:
	if current_index < current_queue.size():
		var raw_text = current_queue[current_index]
		var processed_text = _corrupt_text(raw_text)

		text_box.text = processed_text
		text_box.visible_ratio = 0.0
		is_typing = true

		var tween = create_tween()

		var speed := 1.0
		if corruption_level == 2:
			speed = 3.0
		elif corruption_level == 1:
			speed = 0.7

		tween.tween_property(text_box, "visible_ratio", 1.0, speed)
		tween.tween_callback(func(): is_typing = false)

		current_index += 1
	else:
		_end_dialogue()


func _end_dialogue() -> void:
	visible = false
	emit_signal("dialogue_finished")


# ✅ Visual Style (IMPORTANT FIX)
func _apply_visual_style() -> void:
	# ✅ IMPORTANT:
	# Background must NOT cover your AnimatedSprite UI skin,
	# so we keep it transparent!
	background.color = Color(0, 0, 0, 0)  # fully transparent

	# Reset text color
	text_box.add_theme_color_override("default_color", Color.BLACK)

	# If you want overlay tint per corruption:
	if corruption_level == 0:
		background.color = Color(0, 0, 0, 0)  # normal no tint
	elif corruption_level == 1:
		background.color = Color(0, 0, 0, 0.15)  # slight dark
	elif corruption_level == 2:
		background.color = Color(0, 0, 0.25)  # more dim
	elif corruption_level == 3:
		background.color = Color.BLACK
		text_box.add_theme_color_override("default_color", Color.GREEN)
	elif corruption_level == 4:
		background.color = Color.BLACK
		text_box.add_theme_color_override("default_color", Color.BLACK)


# --- TEXT CORRUPTION ---
func _corrupt_text(text: String) -> String:
	match corruption_level:
		0:
			return text
		1:
			return "[shake rate=5 level=10]" + text + "[/shake]"
		2:
			return "[wave amp=20 freq=2]" + text + "[/wave]"
		3:
			var glitched = text.replace("a", "@").replace("e", "3").replace("o", "0")
			glitched = glitched.replace("i", "1").replace("s", "$")
			return "[color=red][shake rate=20 level=20]" + glitched + "[/shake][/color]"
		4:
			return "[code]" + text + "[/code]"
	return text
