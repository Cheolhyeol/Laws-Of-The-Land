extends Node

var save_path := "user://savegame.json"
var game_loaded_data := {}

# --- Salvar jogo ---
func save_game_data(data: Dictionary):
	game_loaded_data = data
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("💾 Dados salvos em:", save_path)
	else:
		push_error("❌ Erro ao abrir arquivo para salvar.")

# --- Carregar jogo ---
func load_game_data() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		print("⚠️ Nenhum save encontrado.")
		return {}
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			game_loaded_data = data
			print("📂 Dados carregados:", data)
			return data
		else:
			push_error("❌ Erro ao ler o JSON do save.")
			return {}
	else:
		push_error("❌ Erro ao abrir arquivo para leitura.")
		return {}

# --- Verifica se existe save ---
func has_save() -> bool:
	return FileAccess.file_exists(save_path)
