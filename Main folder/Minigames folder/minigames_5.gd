extends Control

# --- REQUIRED: Signal for StageController ---
signal minigame_finished(success)

@onready var progress_bar: ProgressBar = $Panel/ProgressBar
@onready var download_button: Button = $Panel/DownloadButton
@onready var status_label: Label = $Panel/StatusLabel
@onready var timer: Timer = $Panel/Timer

var downloading := false
var download_speed := 1.2
var is_complete := false

func _ready():
	progress_bar.value = 0
	status_label.text = "Waiting for download..."
	
	# Connect timer and button
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	
	if not download_button.pressed.is_connected(_on_download_pressed):
		download_button.pressed.connect(_on_download_pressed)

func _on_download_pressed():
	# CASE 1: Download finished, player clicks "Done" -> Trigger Popup
	if is_complete:
		status_label.text = "System Accepted."
		download_button.disabled = true
		
		# Emit the signal to StageController to show the Popup
		minigame_finished.emit(true)
		return

	# CASE 2: Start the download
	if not downloading:
		downloading = true
		progress_bar.value = 0
		status_label.text = "Downloading..."
		
		# Disable button while downloading so they can't click it
		download_button.disabled = true
		timer.start()

func _on_timer_timeout():
	progress_bar.value += download_speed

	if progress_bar.value >= progress_bar.max_value:
		_complete_download()

func _complete_download():
	timer.stop()
	downloading = false
	is_complete = true
	
	progress_bar.value = progress_bar.max_value
	status_label.text = "Download Complete!"
	
	# IMPORTANT: Re-enable the button and change text
	download_button.text = "Done"
	download_button.disabled = false
