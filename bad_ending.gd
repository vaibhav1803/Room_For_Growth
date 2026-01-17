extends Control

@onready var video_stream_player = $VideoStreamPlayer
@onready var ending_text = $Label

func _ready():
	# Start with video visible and label hidden
	video_stream_player.visible = true
	ending_text.visible = false
	
	# Play the video
	video_stream_player.play()
	
	# Connect the finished signal to a function
	video_stream_player.connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished():
	# Hide the video and show the label when video ends
	video_stream_player.visible = false
	ending_text.visible = true
