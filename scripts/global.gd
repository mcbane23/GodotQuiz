extends Node

var labels_data: Array = read_json_file("res://data/labels.json")

# configure round time, number of questions per game and language
var game_time: int = 10
var game_number_of_questions: int = 5
var language = "en"
var category = ""

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
	
# Function to get label by key and language
func get_label(key: String) -> String:
	for label in labels_data:
		if label.key == key:
			return label.translations[language] if language in label.translations else "Translation not found"
	return "Key not found"
