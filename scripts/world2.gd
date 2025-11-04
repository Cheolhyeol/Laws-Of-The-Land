extends Node2D

# Duração do turno: 4 minutos (240 segundos)
var turn_duration := 5.0
var time_left := turn_duration
var turn_count := 0
var turn_active := false

@onready var timer_label := $UI/TurnoLabel
@onready var start_button := $UI/IniciarTurnoButton
@onready var ampulheta_sprite := $UI/Ampulheta

func _ready():
	update_timer_label()
	update_button_text()
	start_button.visible = true
	turn_active = false
	ampulheta_sprite.stop() # Garante que começa parada

func _process(delta):
	if turn_active:
		time_left -= delta
		if time_left <= 0:
			end_turn()
		update_timer_label()

func _on_iniciar_turno_button_pressed() -> void:
	start_turn()

func start_turn():
	turn_active = true
	start_button.visible = false
	ampulheta_sprite.frame = 0
	ampulheta_sprite.play("ampulheta")
	print("Turno ", turn_count + 1, " iniciado!")

func end_turn():
	turn_count += 1
	turn_active = false
	time_left = turn_duration
	start_button.visible = true
	ampulheta_sprite.stop()
	print("Turno ", turn_count, " finalizado!")
	update_timer_label()
	update_button_text()
	print("Turno ", turn_count, " finalizado!")

func update_timer_label():
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	var texto = "Próximo turno em: %02d:%02d" % [minutes, seconds]
	timer_label.text = texto

func update_button_text():
	var proximo_turno = turn_count + 1
	start_button.text = "Iniciar Turno " + str(proximo_turno)
