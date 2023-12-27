extends Button

@onready var remote_user_id_field := $"../ConnectFields/RemoteUserId/RemoteUserIdField"

signal connect_pressed(socket_id: String, remote_user_id: String)

func _on_pressed():
	connect_pressed.emit("beef", remote_user_id_field.text)
