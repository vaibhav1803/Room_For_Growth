extends AudioStreamPlayer

const menu_music = preload("res://assets/audio/menu.wav")
const loop_1_music = preload("res://assets/audio/Loop_1_Nostalgia.wav")
const loop_2_music = preload("res://assets/audio/Loop_2_Memory.wav")
const loop_3_music = preload("res://assets/audio/Loop_3_Truth.wav")
const loop_4_music = preload("res://assets/audio/Loop_4_Delusion.wav")

# Function to play Loop 1
func play_loop_1():
	stream = loop_1_music
	play()

# Automatically play Loop 1 when this node is added to any scene
func _ready():
	play_loop_1()
