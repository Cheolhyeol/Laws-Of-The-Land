extends HBoxContainer

signal request_start
signal request_delete

var label_slot: Label
var load_btn: Button  
var delete_btn: Button
var slot_number: int

func _ready():
	# Buscar nós
	var children = get_children()
	
	if children.size() >= 1:
		label_slot = children[0] as Label
	if children.size() >= 2:
		load_btn = children[1] as Button
	if children.size() >= 3:
		delete_btn = children[2] as Button
	
	# CONFIGURAÇÃO VISUAL CRÍTICA
	custom_minimum_size = Vector2(400, 80)  # Largura e altura mínimas
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	# Garantir que os elementos internos se expandam
	if label_slot:
		label_slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if load_btn:
		load_btn.custom_minimum_size.x = 100
	if delete_btn:
		delete_btn.custom_minimum_size.x = 100

func setup(slot: int, exists: bool) -> void:
	if not label_slot or not load_btn or not delete_btn:
		return
	
	slot_number = slot
	label_slot.text = "Slot %d" % slot
	load_btn.text = "Carregar"
	delete_btn.text = "Excluir"
	load_btn.disabled = not exists
	delete_btn.disabled = not exists
	
	# Cor dos botões para melhor visibilidade
	if load_btn.disabled:
		load_btn.modulate = Color.GRAY
	if delete_btn.disabled:
		delete_btn.modulate = Color.GRAY
	
	# Limpar e reconectar sinais
	if load_btn.is_connected("pressed", _on_load_pressed):
		load_btn.pressed.disconnect(_on_load_pressed)
	if delete_btn.is_connected("pressed", _on_delete_pressed):
		delete_btn.pressed.disconnect(_on_delete_pressed)
	
	load_btn.pressed.connect(_on_load_pressed)
	delete_btn.pressed.connect(_on_delete_pressed)

func _on_load_pressed():
	request_start.emit()

func _on_delete_pressed():
	request_delete.emit()
