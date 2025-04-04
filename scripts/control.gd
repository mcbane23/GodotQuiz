extends Control

@onready var DisplayText = $Question
@onready var Result = $Result
@onready var RestartButton = $RestartButton
@onready var Button1 = $VBoxContainer/Button1
@onready var Button2 = $VBoxContainer/Button2
@onready var Button3 = $VBoxContainer/Button3
@onready var Clock = $Timer

# configure round time and number of questions per game
var game_time: int = 30
var game_number_of_questions: int = 10

var questions : Array = read_json_file("res://questions.json")
var item : Dictionary
var question_number: int = 1
var correct_answers : float = 0
var clock: int = 0
var answer_selected: bool = false
var game_end: bool = false

func read_json_file(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var str_content = file.get_as_text()
	file.close()
	var json_content = JSON.parse_string(str_content)
	print(json_content)
	return json_content 
	
# Called when the node enters the scene tree for the first time.
func _ready():
	RestartButton.text = "Започни нову игру"
	refresh_scene()

func refresh_scene():
	answer_selected = false
	game_end = false
	reset_timer()
	if question_number > game_number_of_questions:
		show_result()
	else:
		show_question()
		
func show_question():
	hide_buttons(false)
	# shuffle questions
	questions.shuffle()
	# pick first one from shuffled array
	item = questions[0]
	# remove selected question from array
	questions.remove_at(0)
	DisplayText.text = str(question_number, ". ", item.question)
	Button1.text = item.options[0]
	Button2.text = item.options[1]
	Button3.text = item.options[2]
		
func show_result():
	hide_buttons(true)
	game_end = true
	var score = round(correct_answers / game_number_of_questions * 100)
	var greet
	if score >= 60:
		greet = "Честитам"
	else:
		greet = "Ох, не"
	DisplayText.text = "{greet}! Твој резултат је: {correct} ({score}%)".format({"greet": greet, "correct": int(correct_answers), "score": score})

# show/hide elements
func hide_buttons(state):
	if state == false:
		Button1.show()
		Button2.show()
		Button3.show()
		Clock.show()
		RestartButton.hide()
	else:
		Button1.hide()
		Button2.hide()
		Button3.hide()
		Clock.hide()
		RestartButton.show()
	Result.hide()
	
func _on_restart_button_pressed():
	questions = read_json_file("res://questions.json")
	correct_answers = 0
	question_number = 1
	refresh_scene()

func _on_option_button_pressed(number):
	if answer_selected == false:
		var resultText = ""
		if number == item.correctOptionIndex:
			correct_answers += 1
			resultText = "Тачно"
		else:
			resultText = "Нетачно"
		question_number += 1
		delay_next_screen(resultText)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_timer_timeout():
	clock -= 1
	if clock == 0 and answer_selected == false and game_end == false:
		question_number += 1
		delay_next_screen("Време је истекло")
	else:
		Clock.text = str(clock)

func reset_timer():
	clock = game_time
	Clock.text = str(clock)

func delay_next_screen(text):
	Clock.hide()
	Result.show()
	answer_selected = true
	Result.text = text
	await get_tree().create_timer(2).timeout
	reset_timer()
	refresh_scene()
