extends Control

@onready var DisplayText = $Background/MarginContainer/Rows/Result
@onready var RestartButton = $Background/MarginContainer/Rows/RestartButton
@onready var ExitButton = $Background/MarginContainer/Rows/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	RestartButton.text = Global.get_label("restart_game")
	ExitButton.text = Global.get_label("exit")
	show_result()
	
func show_result():
	var score_percent: float = round(Global.correct_answers / Global.game_number_of_questions * 100)
	var score_value: int = Global.calculate_score()
	var greet: String
	if score_percent >= 60:
		greet = Global.get_label("congrats")
	else:
		greet = Global.get_label("oh_no")
	DisplayText.text = "{greet}! {your_result_is}: {score_value} ({percent}%)".format({"greet": greet, "your_result_is": Global.get_label("your_result_is"), "score_value": score_value, "percent": score_percent})

func _on_restart_button_pressed():
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
