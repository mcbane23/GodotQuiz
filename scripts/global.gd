extends Node

var labels_data: Array = read_json_file("res://data/labels.json")

# configure round time, number of questions per game and language
var game_time: int = 30
var game_number_of_questions: int = 10
var language = "sr"

func read_json_file(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var str_content = file.get_as_text()
	file.close()
	var json_content = JSON.parse_string(str_content)
	print(json_content)
	return json_content 
	
# Function to get label by key and language
func get_label(key: String) -> String:
	for label in labels_data:
		if label.key == key:
			return label.translations[language] if language in label.translations else "Translation not found"
	return "Key not found"
