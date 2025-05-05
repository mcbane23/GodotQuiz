extends Control

@onready var Title = $Title

# Called when the node enters the scene tree for the first time.
func _ready():
	set_defaults()


func set_defaults():
	change_lang("sr")
	Global.category = "school"


func _on_exit_button_pressed():
	get_tree().quit()


func _on_sr_pressed():
	change_lang("sr")


func _on_en_pressed():
	change_lang("en")


func change_lang(lang):
	Global.language = lang
	TranslationServer.set_locale(lang)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
