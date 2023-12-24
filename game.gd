extends Node2D

@export var spawn_time: float = 1.0

@onready var gui := $"../GUI"
@onready var level_scene := preload("res://levels/basic_level.tscn")
@onready var peer: EOSGMultiplayerPeer = EOSGMultiplayerPeer.new()
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

var _spawn_timers: Dictionary

func _ready() -> void:
	peer.peer_connection_closed.connect(_on_peer_connection_closed)
	peer.peer_connected.connect(_on_peer_connected)
	peer.peer_disconnected.connect(_on_peer_disconnected)

func _process(delta: float) -> void:
	if _spawn_timers.size() == 0: return
	
	var to_remove: Array[int]
	for peer in _spawn_timers:
		_spawn_timers[peer] -= delta
		if _spawn_timers[peer] <= 0:
			spawn_player(peer)
			to_remove.push_back(peer)
	
	for peer in to_remove:
		_spawn_timers.erase(peer)

func _on_create_server_button_pressed() -> void:
	var result := peer.create_server("beef")
	if result != OK:
		return
	multiplayer.multiplayer_peer = peer
	
	#spawn level
	var level = level_scene.instantiate()
	$"Level".add_child(level)
	$"../GUI/PlayerHUD".visible = true
	spawn_player(1)

func spawn_player(peer_id: int) -> void:
	var player = preload("res://player/Player.tscn").instantiate()
	player.name = str(peer_id)
	player.owner_id = peer_id
	var max_x = get_viewport().get_visible_rect().size.x
	var max_y = get_viewport().get_visible_rect().size.y
	var rand_pos := Vector2(randi_range(10, max_x - 10), randi_range(10, max_y - 10))
	player.position = rand_pos
	player.died.connect(_on_player_died)
	$"Level".add_child(player, true)
	GlobalData.players[peer_id] = player as PlayerCharacter

func unspawn_player(peer_id: int) -> void:
	if GlobalData.players.has(peer_id):
		GlobalData.players[peer_id].queue_free()
	else:
		printerr("Failed to unspawn player. Player not found.")

func _on_connect_to_server_menu_connect_pressed(socket_id, remote_user_id) -> void:
	var result := peer.create_client(socket_id, remote_user_id)
	if result != OK:
		return
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(peer_id: int) -> void:
	if peer.get_active_mode() == EOS.P2P.Mode.Client and peer_id == 1:
		gui.connection_status.visible = false
		$"../GUI/PlayerHUD".visible = true
	if peer.get_active_mode() == EOS.P2P.Mode.Server:
		spawn_player(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer has disconnected. Peer id: " + str(peer_id))
	if peer.get_active_mode() == EOS.P2P.Mode.Server:
		unspawn_player(peer_id)

func _on_disconnect_button_pressed() -> void:
	_clear_level()
	peer.close()
	gui.set_connection_status_label("Disconnected by local user.")
	gui.connection_status.get_node("BackButton").visible = true
	gui.connection_status.visible = true
	$"../GUI/PlayerHUD".visible = false

func _remove_respawn_timer(peer_id: int) -> void:
	if _spawn_timers.has(peer_id):
		_spawn_timers.erase(peer_id)

func _on_peer_connection_closed(data: Dictionary) -> void:
	match data.reason:
		EOS.P2P.ConnectionClosedReason.ClosedByPeer:
			if peer.get_active_mode() != EOS.P2P.Mode.Server:
				$"../GUI/PlayerHUD".visible = false
				gui.connection_status.visible = true
				gui.set_connection_status_label("Host has disconnected")
				gui.connection_status.get_node("BackButton").visible = true
		_: #There was an error
			gui.set_connection_status_label("Connection Failed")
			gui.connection_status.get_node("BackButton").visible = true

func _on_player_died(player: PlayerCharacter) -> void:
	player.died.disconnect(_on_player_died)
	unspawn_player(player.owner_id)
	_spawn_timers[player.owner_id] = spawn_time

func _clear_level() -> void:
	for child in $"Level".get_children():
		child.queue_free()
