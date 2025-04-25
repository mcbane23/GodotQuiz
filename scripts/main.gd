extends Control

@onready var ExitButton = $Background/MarginContainer/Rows/ExitButton
@onready var StartButton = $Background/MarginContainer/Rows/Start

# Called when the node enters the scene tree for the first time.
func _ready():
	set_defaults()

func set_defaults():
	Global.language = "sr"
	Global.category = "school"
	update_buttons()
		
func _on_exit_button_pressed():
	get_tree().quit()

func _on_sr_pressed():
	Global.language = "sr"
	update_buttons()

func _on_en_pressed():
	Global.language = "en"
	update_buttons()

func update_buttons():
	StartButton.text = Global.get_label("start")
	ExitButton.text = Global.get_label("exit")
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
