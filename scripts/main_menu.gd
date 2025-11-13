extends Node2D

@onready var start_button := $CanvasLayer/Panel/VBoxContainer/StartButton
@onready var load_button := $CanvasLayer/Panel/VBoxContainer/LoadButton
@onready var quit_button := $CanvasLayer/Panel/VBoxContainer/QuitButton
@onready var save_status_label := $CanvasLayer/Panel/VBoxContainer/SaveStatusLabel

const DEFAULT_GAME_SCENE := "res://scenes/world.tscn" # Caminho da sua cena de jogo

func _ready():
	print("=== 🧠 Diagnóstico de Autoload Global ===")
	print("Engine.has_singleton('Global') =", Engine.has_singleton("Global")) # Vai dar false — normal
	print("get_tree().root.has_node('Global') =", get_tree().root.has_node("Global"))
	
	

	if get_tree().root.has_node("Global"):
		var global = get_tree().root.get_node("Global")
		print("✅ Global carregado com sucesso!")
		print("Conteúdo atual do Global.game_loaded_data:", global.game_loaded_data)
	else:
		push_error("❌ ERRO: Autoload Global não encontrado na árvore! Verifique o Project Settings > Autoload.")

	print("✅ MainMenu carregado com sucesso!")

	# Conecta botões
	start_button.pressed.connect(_on_start_pressed)
	load_button.pressed.connect(_on_load_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Atualiza o status do save
	_update_save_status()


# --- Atualiza texto do status de save ---
func _update_save_status():
	var global = get_tree().root.get_node("Global")
	if global.has_save():
		save_status_label.text = "💾 Save encontrado!"
		load_button.disabled = false
	else:
		save_status_label.text = "⚠️ Nenhum save disponível."
		load_button.disabled = true


# --- Inicia novo jogo ---
func _on_start_pressed():
	print("▶️ Novo jogo iniciado!")
	var global = get_tree().root.get_node("Global")
	global.game_loaded_data.clear()
	get_tree().change_scene_to_file(DEFAULT_GAME_SCENE)


# --- Carrega jogo salvo ---
func _on_load_pressed():
	print("📂 Carregando jogo salvo...")
	var global = get_tree().root.get_node("Global")
	var data = global.load_game_data()
	if data.is_empty():
		print("⚠️ Nenhum dado para carregar.")
		return
	global.game_loaded_data = data
	get_tree().change_scene_to_file(DEFAULT_GAME_SCENE)


# --- Sai do jogo ---
func _on_quit_pressed():
	print("👋 Saindo do jogo...")
	get_tree().quit()
