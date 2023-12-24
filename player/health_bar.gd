extends HBoxContainer

@onready var progress_bar := $TexturedProgressBar

func _ready():
	GlobalData.local_player_spawned.connect(_on_local_player_spanwed)

func _on_local_player_spanwed(player: PlayerCharacter):
	progress_bar.max_value = player.max_health
	progress_bar.value = player.max_health
	player.current_health_changed.connect(_on_local_player_health_changed)
	player.died.connect(_on_local_player_die)
	
func _on_local_player_die(player: PlayerCharacter):
	progress_bar.value = 0
	player.current_health_changed.disconnect(_on_local_player_health_changed)
	player.died.disconnect(_on_local_player_die)

func _on_local_player_health_changed(current_health: int):
	progress_bar.value = current_health
