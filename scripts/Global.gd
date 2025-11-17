extends Control

const SAVE_DIR := "user://saves/"
const MAX_SLOTS := 5

var current_slot: int = 0
var game_loaded_data: Dictionary = {}

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	
	print("--- DIAGNÓSTICO ---")
	print("SAVE_DIR =", SAVE_DIR)
	print("Conteúdo de list_save_slots() =", Global.list_save_slots())
	print("--- FIM ---")

	

func debug_save_slots():
	print("=== DEBUG SAVE SLOTS ===")
	print("Save dir: ", SAVE_DIR)
	
	var dir = DirAccess.open(SAVE_DIR)
	if not dir:
		print("❌ Não foi possível abrir o diretório de saves")
		return []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var slots = []
	
	while file_name != "":
		if file_name.ends_with(".save"):
			print("Arquivo encontrado: ", file_name)
			var slot_num = file_name.trim_suffix(".save").to_int()
			slots.append({"slot": slot_num, "exists": true})
		file_name = dir.get_next()
	
	print("Slots encontrados: ", slots)
	return slots
# ===============================
# 🔍 UTILITÁRIOS DE SLOT
# ===============================

func get_slot_path(slot: int) -> String:
	return "%sslot_%d.save" % [SAVE_DIR, slot]

func get_slot_filename(slot: int) -> String:
	return "slot_%d.save" % slot

func slot_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_slot_path(slot))


# Retorna dados completos de cada slot para suas UIs
func list_save_slots() -> Array:
	var slots: Array = []

	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

	var dir := DirAccess.open(SAVE_DIR)
	if dir == null:
		print("❌ Não conseguiu abrir pasta de saves:", SAVE_DIR)
		return slots

	dir.list_dir_begin()
	var fname := dir.get_next()

	while fname != "":
		if not dir.current_is_dir() and fname.ends_with(".save"):
			var slot_num := fname.replace("slot_", "").replace(".save", "").to_int()
			slots.append({
				"slot": slot_num,
				"exists": true,
				"file": fname,
				"path": SAVE_DIR + fname
			})
		fname = dir.get_next()

	dir.list_dir_end()

	return slots






# ===============================
# 💾 SALVAR / CRIAR
# ===============================

func save_to_slot(slot: int, data: Dictionary) -> bool:
	var path := get_slot_path(slot)
	var file := FileAccess.open(path, FileAccess.WRITE)

	if file == null:
		return false

	file.store_var(data)
	file.flush()
	file.close()
	return true


func create_new_slot(slot: int, data: Dictionary) -> bool:
	return save_to_slot(slot, data)


# ===============================
# 📂 CARREGAR
# ===============================

func load_from_slot(slot: int) -> Dictionary:
	var path := get_slot_path(slot)

	if not FileAccess.file_exists(path):
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}

	var data: Variant = file.get_var()
	file.close()

	return data if typeof(data) == TYPE_DICTIONARY else {}



# ===============================
# ❌ DELETAR
# ===============================

func delete_slot(slot: int) -> bool:
	var path := get_slot_path(slot)

	if not FileAccess.file_exists(path):
		return false

	return DirAccess.remove_absolute(path) == OK
