extends Node

var jump_sfx: AudioStream
var death_sfx: AudioStream
var troll_sfx: AudioStream
var trap_sfx: AudioStream
var door_sfx: AudioStream
var win_sfx: AudioStream

var is_muted: bool = false
var audio_players: Array[AudioStreamPlayer] = []
var max_players: int = 8

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if ResourceLoader.exists("res://audio/jump.wav"):
		jump_sfx = load("res://audio/jump.wav")
	if ResourceLoader.exists("res://audio/death.wav"):
		death_sfx = load("res://audio/death.wav")
	if ResourceLoader.exists("res://audio/troll.wav"):
		troll_sfx = load("res://audio/troll.wav")
	if ResourceLoader.exists("res://audio/trap.wav"):
		trap_sfx = load("res://audio/trap.wav")
	if ResourceLoader.exists("res://audio/door.wav"):
		door_sfx = load("res://audio/door.wav")
	if ResourceLoader.exists("res://audio/win.wav"):
		win_sfx = load("res://audio/win.wav")

	for i in range(max_players):
		var p = AudioStreamPlayer.new()
		add_child(p)
		audio_players.append(p)

func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	if is_muted or stream == null:
		return
	for p in audio_players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.play()
			return
	# If all busy, use the first one
	if audio_players.size() > 0:
		var p = audio_players[0]
		p.stream = stream
		p.volume_db = volume_db
		p.play()

func play_jump() -> void:
	play_sfx(jump_sfx, -3.0)

func play_death() -> void:
	play_sfx(death_sfx, 0.0)

func play_troll() -> void:
	play_sfx(troll_sfx, -2.0)

func play_trap() -> void:
	play_sfx(trap_sfx, -2.0)

func play_door() -> void:
	play_sfx(door_sfx, 0.0)

func play_win() -> void:
	play_sfx(win_sfx, 0.0)

func toggle_mute() -> bool:
	is_muted = !is_muted
	return is_muted
