extends Control

@onready var DisplayText = $Question
@onready var Result = $Result
@onready var RestartButton = $RestartButton
@onready var ExitButton = $ExitButton
@onready var Button1 = $VBoxContainer/Button1
@onready var Button2 = $VBoxContainer/Button2
@onready var Button3 = $VBoxContainer/Button3
@onready var Clock = $Timer

# configure round time and number of questions per game
var game_time: int = Global.game_time
var game_number_of_questions: int = Global.game_number_of_questions
var language = Global.language

var questions : Array = Global.read_json_file("res://data/questions_" + language + ".json")
var labels_data: Array = Global.read_json_file("res://data/labels.json")
var item : Dictionary
var question_number: int = 1
var correct_answers : float = 0
var clock: int = 0
var answer_selected: bool = false
var game_end: bool = false

var stylebox_theme_normal: StyleBoxFlat
var stylebox_theme_hover: StyleBoxFlat
var stylebox_theme_pressed: StyleBoxFlat
const green = Color(0.0, 0.8, 0.0)
const red = Color(0.8,0.0,0.0,1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	stylebox_theme_normal = Button1.get_theme_stylebox("normal")
	stylebox_theme_hover = Button1.get_theme_stylebox("hover")
	stylebox_theme_pressed = Button1.get_theme_stylebox("pressed")
	RestartButton.text = Global.get_label("restart_game")
	ExitButton.text = Global.get_label("exit")
	refresh_scene()

func refresh_scene():
	answer_selected = false
	game_end = false
	reset_timer()
	reset_button_style()
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
		greet = Global.get_label("congrats")
	else:
		greet = Global.get_label("oh_no")
	DisplayText.text = "{greet}! {your_result_is}: {correct} ({score}%)".format({"greet": greet, "your_result_is": Global.get_label("your_result_is"), "correct": int(correct_answers), "score": score})

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
	questions = Global.read_json_file("res://data/questions_" + language + ".json")
	correct_answers = 0
	question_number = 1
	refresh_scene()

func _on_option_button_pressed(number):
	if answer_selected == false:
		var resultText = ""
		if number == item.correctOptionIndex:
			correct_answers += 1
			highlight_button(number, green)
			resultText = Global.get_label("correct")
		else:
			highlight_button(number, red)
			resultText = Global.get_label("incorrect")
		question_number += 1
		delay_next_screen(resultText)

func highlight_button(number, color):
	match number:
		0:
			set_stylebox_color(Button1, color)
		1:
			set_stylebox_color(Button2, color)
		2:
			set_stylebox_color(Button3, color)
			
func set_stylebox_color(button, color: Color):
	var new_stylebox : StyleBoxFlat = StyleBoxFlat.new()
	new_stylebox.bg_color = color
	new_stylebox.border_color = color
	button.add_theme_stylebox_override("normal", new_stylebox)
	button.add_theme_stylebox_override("hover", new_stylebox)
	button.add_theme_stylebox_override("pressed", new_stylebox)

func reset_button_style():
	Button1.add_theme_stylebox_override("normal", stylebox_theme_normal)
	Button2.add_theme_stylebox_override("normal", stylebox_theme_normal)
	Button3.add_theme_stylebox_override("normal", stylebox_theme_normal)
	Button1.add_theme_stylebox_override("hover", stylebox_theme_hover)
	Button2.add_theme_stylebox_override("hover", stylebox_theme_hover)
	Button3.add_theme_stylebox_override("hover", stylebox_theme_hover)
	Button1.add_theme_stylebox_override("pressed", stylebox_theme_pressed)
	Button2.add_theme_stylebox_override("pressed", stylebox_theme_pressed)
	Button3.add_theme_stylebox_override("pressed", stylebox_theme_pressed)
	
func _on_exit_button_pressed():
	get_tree().quit()

func _on_timer_timeout():
	clock -= 1
	if clock == 0 and answer_selected == false and game_end == false:
		question_number += 1
		delay_next_screen(Global.get_label("time_is_up"))
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
