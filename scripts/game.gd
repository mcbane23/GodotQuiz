extends Control

@onready var DisplayText = $Background/MarginContainer/Rows/Question
@onready var ExitButton = $Background/MarginContainer/Rows/ExitButton
@onready var Button1 = $Background/MarginContainer/Rows/GridContainer/Button1
@onready var Button2 = $Background/MarginContainer/Rows/GridContainer/Button2
@onready var Button3 = $Background/MarginContainer/Rows/GridContainer/Button3
@onready var VisualTimer = $Background/MarginContainer/Rows/PanelContainer/TimerPanel/ColorRect
@onready var TimerPanel = $Background/MarginContainer/Rows/PanelContainer/TimerPanel
@onready var Result = $Background/MarginContainer/Rows/PanelContainer/Result
@onready var _Timer = $Timer

var questions : Array = Global.get_questions()
var item : Dictionary
var question_number: int = 1
var clock: int = 0
var answer_selected: bool = false
var game_end: bool = false

var stylebox_theme_disabled: StyleBoxFlat
const green = Color(0.0, 0.863, 0.494)
const red = Color(0.694,0.13,0.122)

# Called when the node enters the scene tree for the first time.
func _ready():
	stylebox_theme_disabled = Button1.get_theme_stylebox("disabled")
	ExitButton.text = Global.get_label("exit")
	refresh_scene()

func refresh_scene():
	answer_selected = false
	game_end = false
	reset_timer()
	reset_button_style()
	if question_number > Global.game_number_of_questions:
		game_end = true
		get_tree().change_scene_to_file("res://scenes/result.tscn")
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
	Button1.text = item.option1
	Button2.text = item.option2
	Button3.text = item.option3

# show/hide elements
func hide_buttons(state):
	if state == false:
		Button1.show()
		Button2.show()
		Button3.show()
		TimerPanel.show()
	else:
		Button1.hide()
		Button2.hide()
		Button3.hide()
		TimerPanel.hide()
	Result.hide()

func _on_option_button_pressed(number):
	if answer_selected == false:
		if number == item.correctOption:
			Global.correct_answers += 1
			highlight_button(number, green)
			disable_buttons()
		else:
			highlight_button(number, red)
			disable_buttons()
		question_number += 1
		delay_next_screen()

func highlight_button(number, color):
	var new_stylebox : StyleBoxFlat = StyleBoxFlat.new()
	new_stylebox.bg_color = color
	match number:
		1:
			Button1.add_theme_stylebox_override("disabled", new_stylebox)
		2:
			Button2.add_theme_stylebox_override("disabled", new_stylebox)
		3:
			Button3.add_theme_stylebox_override("disabled", new_stylebox)
			
func disable_buttons():
	Button1.disabled = true
	Button2.disabled = true
	Button3.disabled = true
	
func enable_buttons():
	Button1.disabled = false
	Button2.disabled = false
	Button3.disabled = false

func reset_button_style():
	enable_buttons()
	Button1.add_theme_stylebox_override("disabled", stylebox_theme_disabled)
	Button2.add_theme_stylebox_override("disabled", stylebox_theme_disabled)
	Button3.add_theme_stylebox_override("disabled", stylebox_theme_disabled)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_timer_timeout():
	clock -= 1
	VisualTimer.size.x -= (Global.screen_size.x - 40) / Global.game_time
	if clock == 0 and answer_selected == false and game_end == false:
		question_number += 1
		Result.show()
		Result.text = Global.get_label("time_is_up")
		delay_next_screen()

func reset_timer():
	clock = Global.game_time
	VisualTimer.size.x = Global.screen_size.x - 40
	_Timer.start()

func delay_next_screen():
	disable_buttons()
	TimerPanel.hide()
	_Timer.stop()
	answer_selected = true
	await get_tree().create_timer(2).timeout
	reset_timer()
	refresh_scene()
