extends Node2D


func _ready():
	pass


func start(text: String):
	$Label.text = text
	
	var tween = create_tween()
	
	tween.set_parallel() # Inicia os tween_property abaixo simultaneamente 
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .2)\
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
