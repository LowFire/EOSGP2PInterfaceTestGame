extends Control

@onready var main_menu = $MainMenu
@onready var main_menu_options := $MainMenu/MainMenuOptions
@onready var connect_to_server_menu := $MainMenu/ConnectToServerMenu
@onready var local_user_id_field := $"../LocalUserId"
@onready var connection_status := $ConnectionStatus
@onready var login := $Login
@onready var login_status := $LoginStatus
@onready var player_hud := $PlayerHUD


func _on_connect_to_server_menu_back_button_pressed():
	main_menu_options.visible = true
	connect_to_server_menu.visible = false

func _on_device_id_login_button_pressed():
	login.visible = false
	login_status.visible = true

func _on_login_button_pressed():
	login.visible = false
	login_status.visible = true

func set_login_status_label(message: String):
	login_status.get_node("Label").text = message

func set_connection_status_label(message: String):
	connection_status.get_node("Status").text = message

func _on_login_back_button_pressed():
	set_login_status_label("Loggin in...")
	login_status.visible = false
	login.visible = true

func _on_server_connect_button_pressed():
	main_menu.visible = false
	connection_status.visible = true

func _on_create_client_button_pressed():
	main_menu_options.visible = false
	connect_to_server_menu.visible = true

func _on_connection_status_back_button_pressed():
	set_connection_status_label("Connecting...")
	connection_status.get_node("BackButton").visible = false
	connection_status.visible = false
	main_menu.visible = true
	
func _on_create_server_button_pressed():
	main_menu.visible = false
