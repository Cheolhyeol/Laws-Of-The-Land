extends Node2D

# --- Referências principais ---
@onready var timer_label: Label = $UI/TurnoLabel
@onready var start_button: Button = $UI/IniciarTurnoButton
@onready var save_button: Button = $UI/SalvarButton
@onready var ampulheta_sprite: AnimatedSprite2D = $UI/Ampulheta
@onready var salvar_mensagem: Label = $UI/SalvarMensagem # novo label para feedback

# --- Variáveis do sistema de turno ---
var turn_duration := 5.0 # segundos
var time_left := turn_duration
var turn_count := 0
var turn_active := false

func _ready():
	print("=== 🌍 Iniciando World Scene ===")

	# --- Obtém referência ao autoload Global ---
	var global = get_tree().root.get_node_or_null("Global")
	if global == null:
		push_error("❌ ERRO: Autoload 'Global' não foi encontrado! O salvamento não funcionará.")
	else:
		print("✅ Autoload Global detectado:", global)
		if global.game_loaded_data and not global.game_loaded_data.is_empty():
			var data = global.game_loaded_data
			if data.has("turn"):
				var turn = data["turn"]
				if turn.has("turn_count"):
					turn_count = turn["turn_count"]
				if turn.has("time_left"):
					time_left = turn["time_left"]
			print("📂 Dados carregados do Global:", data)

	# --- Inicializa UI ---
	update_timer_label()
	update_button_text()
	start_button.visible = true
	turn_active = false
	if ampulheta_sprite:
		ampulheta_sprite.stop()
	if salvar_mensagem:
		salvar_mensagem.visible = false

	# --- Conecta sinais ---
	if start_button:
		start_button.pressed.connect(_on_iniciar_turno_button_pressed)
	if save_button:
		save_button.pressed.connect(_on_salvar_button_pressed)


func _process(delta):
	if turn_active:
		time_left -= delta
		if time_left <= 0:
			end_turn()
		update_timer_label()


# --- Iniciar turno ---
func _on_iniciar_turno_button_pressed() -> void:
	start_turn()


# --- Salvar jogo ---
func _on_salvar_button_pressed() -> void:
	print("💾 Tentando salvar jogo...")

	var global = get_tree().root.get_node_or_null("Global")
	if global == null:
		push_error("❌ ERRO: Autoload 'Global' não encontrado. Não é possível salvar.")
		return

	var data = {
		"turn": {
			"turn_count": turn_count,
			"time_left": time_left
		}
	}

	global.save_game_data(data)
	print("✅ Jogo salvo com sucesso!")
	_exibir_mensagem_salva()


# --- Mensagem visual de feedback ---
func _exibir_mensagem_salva():
	if not salvar_mensagem:
		return
	salvar_mensagem.text = "💾 Jogo salvo com sucesso!"
	salvar_mensagem.visible = true
	await get_tree().create_timer(2.5).timeout
	salvar_mensagem.visible = false


# --- Lógica do turno ---
func start_turn():
	turn_active = true
	start_button.visible = false
	if ampulheta_sprite:
		ampulheta_sprite.frame = 0
		ampulheta_sprite.play("ampulheta")
	print("▶️ Turno ", turn_count + 1, " iniciado!")


func end_turn():
	turn_count += 1
	turn_active = false
	time_left = turn_duration
	start_button.visible = true
	if ampulheta_sprite:
		ampulheta_sprite.stop()
	print("⏹️ Turno ", turn_count, " finalizado!")
	update_timer_label()
	update_button_text()


# --- Atualizações visuais ---
func update_timer_label():
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	timer_label.text = "Próximo turno em: %02d:%02d" % [minutes, seconds]


func update_button_text():
	var proximo_turno = turn_count + 1
	start_button.text = "Iniciar Turno " + str(proximo_turno)
