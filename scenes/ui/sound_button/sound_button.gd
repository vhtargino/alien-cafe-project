extends Button

@onready var random_stream_player_component: AudioStreamPlayer = $RandomStreamPlayerComponent


func _ready():
	pressed.connect(on_pressed)


func check_playing():
	if self.random_stream_player_component.playing:
		await self.random_stream_player_component.finished


func on_pressed():
	random_stream_player_component.play_random()
