# Popup_Manager.gd
extends Control

#pop up manager will always appear at (490,100)

signal next_clicked

@onready var next_button = $NextButton
@onready var popup_text = $ColorRect/PopupText

func _ready():
	next_button.pressed.connect(_on_button_pressed)

func setup_popup(message: String, button_label: String = "OK"):
	popup_text.text = message
	next_button.text = button_label

func _on_button_pressed():
	print("Popup Manager: Button clicked.")
	next_clicked.emit() 
