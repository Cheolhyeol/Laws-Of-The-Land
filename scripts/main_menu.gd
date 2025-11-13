extends Node2D

@onready var start_button := $CanvasLayer/Panel/VBoxContainer/StartButton
@onready var load_button := $CanvasLayer/Panel/VBoxContainer/LoadButton
@onready var quit_button := $CanvasLayer/Panel/VBoxContainer/QuitButton
@onready var save_status_label := $CanvasLayer/Panel/VBoxContainer/SaveStatusLabel

const DEFAULT_GAME_SCENE := "res://scenes/world.tscn" # ajuste para sua cena de jogo

func _ready():
	
	print("=== Testando Global ===")
	
	if Engine.has_singleton("Global"):
		print("✅ O autoload Global está acessível!")
	else:
		print("❌ O autoload Global NÃO foi encontrado!")

	if ProjectSettings.has_setting("autoload/Global"):
		print("⚙️ O Global está registrado no ProjectSettings!")
	else:
		print("⚠️ O Global não está registrado nas configurações!")
		
	print("Conteúdo atual do Global.game_loaded_data:", Global.game_loaded_data)
	print("✅ MainMenu carregado com sucesso!")
	start_button.pressed.connect(_on_start_pressed)
	load_button.pressed.connect(_on_load_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Atualiza status do save
	_update_save_status()

func _update_save_status():
	if Global.has_save():
		save_status_label.text = "💾 Save encontrado!"
		load_button.disabled = false
	else:
		save_status_label.text = "⚠️ Nenhum save disponível."
		load_button.disabled = true

# Inicia novo jogo
func _on_start_pressed():
	print("▶️ Novo jogo iniciado!")
	Global.game_loaded_data.clear()
	get_tree().change_scene_to_file(DEFAULT_GAME_SCENE)

# Carrega jogo salvo
func _on_load_pressed():
	print("📂 Carregando jogo salvo...")
	var data = Global.load_game_data()
	if data.is_empty():
		print("⚠️ Nenhum dado para carregar.")
		return
	Global.game_loaded_data = data
	get_tree().change_scene_to_file(DEFAULT_GAME_SCENE)

# Sair do jogo
func _on_quit_pressed():
	print("👋 Saindo do jogo...")
	get_tree().quit()
