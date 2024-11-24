extends Control

var dialogue_loading: DialogueLoading = DialogueLoading.new()
var dialogues: Dictionary = {}
var current_id: int = 1
var selected_id: int = 0

@onready var dialogue_text: RichTextLabel = $Panel/RichTextLabel
@onready var options: VBoxContainer = $Options/VBoxContainer
@onready var typewriting: AnimationPlayer = $AnimationPlayer

func _ready():
	dialogues = dialogue_loading.load_json_file("res://data/start.json")
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		start_dialogue(current_id)
		typewriting.play("typewriting")
		start_options(current_id)
	
func start_dialogue(id: int):
	var dialogue = dialogues["dialogue_" + str(id)]
	
	if "text" in dialogue:
		dialogue_text.text = dialogue["text"]
	else:
		return

func go_to_next_dialogue(id: int, next_id: int):
	var dialogue = dialogues["dialogue_" + str(id)]
	
	if "options" in dialogue:
		var opts = dialogue["options"].keys()
		for opt in opts:
			if opt == str(next_id):
				dialogue["dest_id"] = int(opt)
		selected_id = dialogue["dest_id"]
	current_id = selected_id
	
func start_options(id: int):
	var dialogue = dialogues["dialogue_" + str(id)]
	
	if "options" in dialogue:
		reset_options(id)
		for opt in dialogue["options"].keys():
			var btn = Button.new()
			btn.text = dialogue["options"][opt]
			btn.name = opt
			btn.connect("pressed", Callable(self, "_on_btn_pressed").bind(opt))
			options.add_child(btn)
			
func _on_btn_pressed(option_id: String):
	var dialogue = dialogues["dialogue_" + str(current_id)]
	var next_id = dialogue["dest_id"]
	next_id = int(option_id)
	go_to_next_dialogue(current_id, next_id)
	
func reset_options(id: int):
	var dialogue = dialogues["dialogue_" + str(id)]
	
	if "options" in dialogue:
		for child in options.get_children():
			child.queue_free()
