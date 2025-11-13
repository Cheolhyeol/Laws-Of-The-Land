extends Node

func _ready():
	print("\n=== 🧠 Diagnóstico de Autoload Global ===")

	# 1️⃣ Verifica se o singleton existe em runtime
	var exists_in_engine := Engine.has_singleton("Global")
	print("Engine.has_singleton('Global') =", exists_in_engine)

	# 2️⃣ Verifica se o nó Global está realmente na árvore
	var exists_in_tree := get_tree().root.has_node("Global")
	print("get_tree().root.has_node('Global') =", exists_in_tree)

	if exists_in_tree:
		var global_node = get_tree().root.get_node("Global")
		print("Tipo de Global:", typeof(global_node))
	else:
		print("❌ O nó Global NÃO está na árvore de execução!")

	# 3️⃣ Verifica se o autoload está registrado nas configurações do projeto
	if ProjectSettings.has_setting("autoload/Global"):
		var setting = ProjectSettings.get_setting("autoload/Global")
		print("⚙️ autoload/Global encontrado no ProjectSettings!")
		print("🔗 Valor registrado:", setting)
	else:
		print("❌ autoload/Global NÃO encontrado nas configurações!")

	# 4️⃣ Verifica se o arquivo Global.gd realmente existe
	var path := "res://scripts/Global.gd"
	if FileAccess.file_exists(path):
		print("📂 O arquivo Global.gd existe em:", path)
	else:
		print("🚫 O arquivo Global.gd NÃO foi encontrado em:", path)

	# 5️⃣ Teste de acesso direto ao singleton (se existir)
	if exists_in_tree:
		var global_node = get_tree().root.get_node("Global")
		if global_node.has_method("save_game_data"):
			print("✅ O método save_game_data existe em Global!")
		else:
			print("⚠️ O Global foi carregado, mas não tem o método save_game_data.")
	else:
		print("🚫 Nenhum nó Global ativo para testar métodos.")

	print("=== Fim do Diagnóstico ===\n")
