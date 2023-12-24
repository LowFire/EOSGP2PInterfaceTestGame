extends Node

signal score_changed(score: int)
signal local_player_spawned(player: PlayerCharacter)

var players: Dictionary = {}

var score: int:
	get:
		return score
	set(value):
		score = value
		score_changed.emit(score)

var local_player: PlayerCharacter:
	get:
		return local_player
	set(value):
		local_player = value
		local_player_spawned.emit(local_player)

@rpc("authority", "call_local", "reliable")
func scored():
	score += 1
