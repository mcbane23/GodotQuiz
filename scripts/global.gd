extends Node

var screen_size = DisplayServer.window_get_size()

# configure round time, number of questions per game and language
var game_time: int = 10
var game_number_of_questions: int = 10
var language = "en"
var category = ""

var correct_answers: float = 0
var time_left: float = 0

var preferences_file = "user://preferences.save"
var score_file = "user://highscore.save"

func calculate_score():
	var total_time: float = game_time * game_number_of_questions
	print ("Total time: ", total_time)
	var score: float = pow(correct_answers, 2) * (1 + time_left / total_time) * 100
	return score


func reset_score():
	time_left = 0
	correct_answers = 0


func get_questions():
	var questions : Array = read_json_file("res://data/questions_" + category + "_" + language + ".json")
	return questions


func read_json_file(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var str_content = file.get_as_text()
	file.close()
	var json_content = JSON.parse_string(str_content)
	#print(json_content)
	return json_content 


func save_score(content):
	var file = FileAccess.open(score_file, FileAccess.WRITE)
	file.store_string(content)


func load_scores():
	var file = FileAccess.open(score_file, FileAccess.READ)
	var content = file.get_as_text()
	return content
