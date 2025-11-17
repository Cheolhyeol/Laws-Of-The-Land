extends Node2D

@onready var start_button: Button = $CanvasLayer/Panel/VBoxContainer/StartButton
@onready var load_button: Button = $CanvasLayer/Panel/VBoxContainer/LoadButton
@onready var quit_button: Button = $CanvasLayer/Panel/VBoxContainer/QuitButton

const DEFAULT_GAME_SCENE: String = "res://scenes/world.tscn"
const SAVE_MENU_SCENE := "res://UI/saveMenu.tscn"

func _ready() -> void:
	print("MainMenu carregado.")
	
	# Verificar quais botões existem
	print("StartButton existe:", start_button != null)
	print("LoadButton existe:", load_button != null)
	print("QuitButton existe:", quit_button != null)

	# Conectar apenas os botões que existem
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
	if load_button:
		load_button.pressed.connect(_on_load_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	print("Iniciando novo jogo...")
	
	# Encontrar o próximo slot disponível
	var next_slot = _find_available_slot()
	
	if next_slot == -1:
		# Se não encontrou slot vazio, criar um novo
		var slots = Global.list_save_slots()
		if slots.is_empty():
			next_slot = 1
		else:
			# Encontrar o maior número de slot e adicionar 1
			var max_slot = 0
			for slot_data in slots:
				if slot_data["slot"] > max_slot:
					max_slot = slot_data["slot"]
			next_slot = max_slot + 1
	
	print("Novo jogo no slot: ", next_slot)
	
	# Limpar dados e definir slot atual
	Global.game_loaded_data.clear()
	Global.current_slot = next_slot
	
	# Iniciar o jogo
	get_tree().change_scene_to_file(DEFAULT_GAME_SCENE)

func _find_available_slot() -> int:
	"""Encontra o primeiro slot vazio disponível"""
	var slots = Global.list_save_slots()
	
	for slot_data in slots:
		var slot_num: int = slot_data["slot"]
		var exists: bool = slot_data["exists"]
		
		if not exists:
			return slot_num
	
	return -1  # Nenhum slot vazio encontrado

func _on_load_pressed() -> void:
	print("Abrindo tela de saves...")
	get_tree().change_scene_to_file(SAVE_MENU_SCENE)

func _on_quit_pressed() -> void:
	get_tree().quit()
