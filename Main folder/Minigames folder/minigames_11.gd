extends Node2D

signal minigame_finished(success: bool)

# -----------------------------
# NODES (Area2D)
# -----------------------------
@onready var bag_hat: Area2D = $BagHat          # Bag1 catches ONLY Hat
@onready var bag_degree: Area2D = $BagDegree    # Bag2 catches ONLY Degree
@onready var hat: Area2D = $Hat
@onready var degree: Area2D = $Degree
@onready var bottom_zone: Area2D = $BottomZone  # Touch = miss

# -----------------------------
# OPTIONAL UI (if you add labels)
# If you don't have these nodes, leave them commented.
# -----------------------------
# @onready var score_label: Label = $ScoreLabel
# @onready var miss_label: Label = $MissLabel

# -----------------------------
# TUNING
# -----------------------------
@export var bag_speed: float = 600.0
@export var fall_speed: float = 180.0

@export var win_score: int = 10       # ✅ Catch 10 to win
@export var max_misses: int = 5

# -----------------------------
# STATE
# -----------------------------
var score: int = 0
var misses: int = 0
var ended: bool = false

# Auto bounds
var left_limit: float
var right_limit: float
var top_spawn_y: float


func _ready() -> void:
	randomize()

	# ✅ AUTO DETECT SCREEN SIZE
	var screen_size := get_viewport_rect().size
	left_limit = 0.0
	right_limit = screen_size.x
	top_spawn_y = -60.0

	# ✅ Place bottom zone at bottom automatically
	_position_bottom_zone()

	# ✅ Connect collision signals (catching)
	if not hat.area_entered.is_connected(_on_hat_entered):
		hat.area_entered.connect(_on_hat_entered)

	if not degree.area_entered.is_connected(_on_degree_entered):
		degree.area_entered.connect(_on_degree_entered)

	# ✅ Miss detection via BottomZone
	if not bottom_zone.area_entered.is_connected(_on_bottom_zone_entered):
		bottom_zone.area_entered.connect(_on_bottom_zone_entered)

	start_game()


# StageController calls this if present
func start_game() -> void:
	score = 0
	misses = 0
	ended = false

	_reset_item(hat)
	_reset_item(degree)

	_place_bags_at_bottom(30.0)

	# Initial positions (apart)
	bag_hat.position.x = right_limit * 0.35
	bag_degree.position.x = right_limit * 0.65

	_update_ui()


func _process(delta: float) -> void:
	if ended:
		return

	_move_bags_separately(delta)

	# Falling items
	hat.position.y += fall_speed * delta
	degree.position.y += fall_speed * delta


# -----------------------------
# MOVEMENT (SEPARATE CONTROLS)
# Bag1 = A/D (bag1_left / bag1_right)
# Bag2 = ←/→ (bag2_left / bag2_right)
# -----------------------------
func _move_bags_separately(delta: float) -> void:
	var dir1 := Input.get_action_strength("bag1_right") - Input.get_action_strength("bag1_left")
	var dir2 := Input.get_action_strength("bag2_right") - Input.get_action_strength("bag2_left")

	bag_hat.position.x += dir1 * bag_speed * delta
	bag_degree.position.x += dir2 * bag_speed * delta

	bag_hat.position.x = clamp(bag_hat.position.x, left_limit + 60, right_limit - 60)
	bag_degree.position.x = clamp(bag_degree.position.x, left_limit + 60, right_limit - 60)


# -----------------------------
# BOTTOM ZONE SETUP
# -----------------------------
func _position_bottom_zone() -> void:
	var screen_size := get_viewport_rect().size

	# Place in bottom center
	bottom_zone.position = Vector2(screen_size.x / 2.0, screen_size.y - 10.0)

	# Resize collision shape to cover full width
	var cs: CollisionShape2D = bottom_zone.get_node_or_null("CollisionShape2D")
	if cs and cs.shape is RectangleShape2D:
		var rect := cs.shape as RectangleShape2D
		rect.size = Vector2(screen_size.x, 40.0)


func _place_bags_at_bottom(margin: float = 30.0) -> void:
	var screen_h := get_viewport_rect().size.y
	bag_hat.position.y = screen_h - margin
	bag_degree.position.y = screen_h - margin


# -----------------------------
# RESET ITEMS
# -----------------------------
func _reset_item(item: Area2D) -> void:
	item.position.y = top_spawn_y
	item.position.x = randf_range(left_limit + 80, right_limit - 80)


# -----------------------------
# CATCH LOGIC
# -----------------------------
func _on_hat_entered(other: Area2D) -> void:
	if ended:
		return

	# ✅ Correct bag catches hat
	if other == bag_hat:
		_add_score()
		_reset_item(hat)
		return

	# ❌ Wrong bag catches hat
	if other == bag_degree:
		_add_miss()
		_reset_item(hat)


func _on_degree_entered(other: Area2D) -> void:
	if ended:
		return

	# ✅ Correct bag catches degree
	if other == bag_degree:
		_add_score()
		_reset_item(degree)
		return

	# ❌ Wrong bag catches degree
	if other == bag_hat:
		_add_miss()
		_reset_item(degree)


# -----------------------------
# MISS LOGIC (BOTTOM ZONE)
# -----------------------------
func _on_bottom_zone_entered(area: Area2D) -> void:
	if ended:
		return

	if area == hat:
		_add_miss()
		_reset_item(hat)
	elif area == degree:
		_add_miss()
		_reset_item(degree)


# -----------------------------
# SCORE / MISS
# -----------------------------
func _add_score() -> void:
	score += 1
	_update_ui()
	print("Score:", score, "Misses:", misses)

	if score >= win_score:
		_end_game(true)


func _add_miss() -> void:
	misses += 1
	_update_ui()
	print("Score:", score, "Misses:", misses)

	if misses >= max_misses:
		_end_game(false)


func _end_game(won: bool) -> void:
	if ended:
		return

	ended = true

	if won:
		print("✅ Catch Minigame WON!")
		minigame_finished.emit(true)
	else:
		print("❌ Catch Minigame LOST!")
		minigame_finished.emit(false)


func _update_ui() -> void:
	# If you add labels, uncomment these
	# score_label.text = "Caught: %d / %d" % [score, win_score]
	# miss_label.text = "Misses: %d / %d" % [misses, max_misses]
	pass
