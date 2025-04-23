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
	var score: float = round(Global.correct_answers / Global.game_number_of_questions * 100)
	var greet: String
	if score >= 60:
		greet = Global.get_label("congrats")
	else:
		greet = Global.get_label("oh_no")
	DisplayText.text = "{greet}! {your_result_is}: {correct} ({score}%)".format({"greet": greet, "your_result_is": Global.get_label("your_result_is"), "correct": int(Global.correct_answers), "score": score})

func _on_restart_button_pressed():
	Global.correct_answers = 0
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
