extends Control

const SAVE_SLOT_ITEM_SCENE := preload("res://UI/SaveSlotItem.tscn")

@onready var slot_list_vbox: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/SlotList
@onready var back_btn: Button = $MarginContainer/VBoxContainer/HBoxContainer/BackButton
@onready var scroll_container: ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer
@onready var margin_container: MarginContainer = $MarginContainer

func _ready() -> void:
	print("=== TESTE VISUAL ===")
	
	# Configurar o ScrollContainer para ser visível
	scroll_container.custom_minimum_size = Vector2(500, 400)  # Tamanho generoso
	
	# Limpar itens antigos
	for child in slot_list_vbox.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Adicionar vários itens de teste COLORIDOS para verificação
	_add_test_item(1, true, Color.GREEN)
	_add_test_item(2, false, Color.YELLOW)
	_add_test_item(3, true, Color.CYAN)
	
	print("Itens de teste adicionados - verifique as cores na tela")
	
	if slot_list_vbox:
		print("SlotList visível:", slot_list_vbox.visible)
		print("SlotList tamanho:", slot_list_vbox.size)
	
	# Conectar botão voltar
	if back_btn:
		back_btn.pressed.connect(_on_back_pressed)
	
	await get_tree().process_frame
	refresh_slots()

func refresh_slots() -> void:
	print("\n--- ATUALIZANDO SLOTS ---")
	
	# Limpar slots antigos
	for child in slot_list_vbox.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var slots: Array = Global.list_save_slots()
	print("Slots encontrados: ", slots.size())
	
	if slots.size() == 0:
		print("Nenhum slot encontrado - adicionando placeholder")
		_add_placeholder()
		return
	
	for i in range(slots.size()):
		var s = slots[i]
		var slot_num: int = s["slot"]
		var exists: bool = s["exists"]
		
		print("Adicionando slot ", slot_num)
		
		var item = SAVE_SLOT_ITEM_SCENE.instantiate()
		slot_list_vbox.add_child(item)
		
		await get_tree().process_frame
		
		# Verificar se o item foi adicionado corretamente
		print("Item adicionado - visível:", item.visible, " tamanho:", item.size)
		
		item.setup(slot_num, exists)
		item.request_start.connect(_on_start_slot.bind(slot_num))
		item.request_delete.connect(_on_delete_slot.bind(slot_num))
	
	print("Total de itens no SlotList: ", slot_list_vbox.get_child_count())
	
	# Forçar atualização da UI
	await get_tree().process_frame
	slot_list_vbox.queue_sort()
	
	# Verificar tamanho final
	print("Tamanho final do SlotList: ", slot_list_vbox.size)
	print("Tamanho final do ScrollContainer: ", scroll_container.size)

func _add_test_item(slot: int, exists: bool, color: Color):
	var item = SAVE_SLOT_ITEM_SCENE.instantiate()
	slot_list_vbox.add_child(item)
	
	await get_tree().process_frame
	
	item.setup(slot, exists)
	
	# Colorir o fundo para verificação visual
	item.modulate = color
	
	item.request_start.connect(_on_start_slot.bind(slot))
	item.request_delete.connect(_on_delete_slot.bind(slot))

func _add_placeholder():
	var label = Label.new()
	label.text = "Nenhum save encontrado"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	slot_list_vbox.add_child(label)

func _on_start_slot(slot: int) -> void:
	print("Iniciando slot: ", slot)
	
	if not Global.slot_exists(slot):
		print("Slot vazio: ", slot)
		return

	var data = Global.load_from_slot(slot)
	Global.current_slot = slot
	Global.game_loaded_data = data

	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_delete_slot(slot: int) -> void:
	print("Excluindo slot: ", slot)
	
	if Global.delete_slot(slot):
		refresh_slots()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
