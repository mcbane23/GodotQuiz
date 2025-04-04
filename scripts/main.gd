extends Control

@onready var ExitButton = $ExitButton
@onready var StartButton = $GridContainer/Start

var labels_data: Array = Global.read_json_file("res://data/labels.json")

# Called when the node enters the scene tree for the first time.
func _ready():
	StartButton.hide()
	ExitButton.text = Global.get_label("exit")

func _on_exit_button_pressed():
	get_tree().quit()


func _on_sr_pressed():
	Global.language = "sr"
	show_start()

func _on_en_pressed():
	Global.language = "en"
	show_start()

func show_start():
	StartButton.text = Global.get_label("start")
	StartButton.show()
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")
