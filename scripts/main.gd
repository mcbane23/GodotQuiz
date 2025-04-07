extends Control

@onready var ExitButton = $ExitButton
@onready var StartButton = $Start

var labels_data: Array = Global.read_json_file("res://data/labels.json")

# Called when the node enters the scene tree for the first time.
func _ready():
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
	get_tree().change_scene_to_file("res://scenes/control.tscn")
