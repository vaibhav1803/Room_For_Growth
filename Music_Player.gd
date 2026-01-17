extends AudioStreamPlayer

const menu_music = preload("res://assets/audio/menu.wav")
const loop_1_music = preload("res://assets/audio/Loop_1_Nostalgia.wav")
const loop_2_music = preload("res://assets/audio/Loop_2_Memory.wav")
const loop_3_music = preload("res://assets/audio/Loop_3_Truth.wav")
const loop_4_music = preload("res://assets/audio/Loop_4_Delusion.wav")

# Function to play Loop 1
func _ready():
	# Identify the correct music for the current scene
	var target_stream = _get_target_stream()
	
	# Check if this node is the Global Singleton (Autoload) or a Local instance
	# In project.godot, the Autoload is named "MusicPlayer"
	if name == "MusicPlayer":
		# I am the Global Manager. 
		# Initial check (e.g. starting game in main_menu)
		if target_stream:
			play_music(target_stream)
	else:
		# I am a Local Instance in a scene.
		# Tell the Global Manager to play the music, then destroy myself.
		# Accessing the singleton by its name "MusicPlayer"
		var global_player = get_node("/root/MusicPlayer")
		if global_player and target_stream:
			global_player.play_music(target_stream)
		
		# Remove this local node so it doesn't double-play
		queue_free()

# Helper to determine track based on scene path
func _get_target_stream():
	var current_scene = get_tree().current_scene
	if not current_scene:
		return null
		
	var path = current_scene.scene_file_path
	
	if "main_menu" in path:
		return menu_music
	elif "loop1" in path:
		return loop_1_music
	elif "loop2" in path:
		return loop_2_music
	elif "loop3" in path:
		return loop_3_music
	elif "loop4" in path:
		return loop_4_music
	
	return null

# Public function called by local instances
func play_music(new_stream):
	# If we are already playing the requested track, do NOT restart.
	# This ensures seamless looping when changing stages within the same loop.
	if stream == new_stream and playing:
		return
	
	# Otherwise, switch tracks
	stream = new_stream
	if stream:
		play()
	else:
		stop()
