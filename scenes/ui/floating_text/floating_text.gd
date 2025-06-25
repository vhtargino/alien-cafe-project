extends Node2D

@onready var label: Label = $Label


func start(text: String, duration: float, color: Color = Color(1, 1, 1, 1), font_size: int = 10):
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	
	var tween = create_tween()
	
	tween.set_parallel() # Inicia os tween_property abaixo simultaneamente 
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	#tween.tween_property(self, "scale", Vector2.ONE, .3)\
	#.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tween.chain() # Vai rodar o próximo comando depois que os dois anteriores terminarem a execução
	
	#tween.tween_property(self, "global_position", global_position + (Vector2.UP * 32), .3)\
	#.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	#tween.chain()
	
	tween.tween_property(self, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain() # Para garantir que o tween_callback seja executado apenas quando os anteriores finalizarem
	# Porque set_parallel ainda está definido como true
	
	tween.tween_callback(queue_free)
