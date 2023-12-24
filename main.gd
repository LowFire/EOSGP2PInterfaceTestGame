extends Node2D

@export var game : Node2D
@export var local_user_id : LineEdit

@onready var dev_credential_field := $GUI/Login/DevCredential/Field
@onready var gui := $GUI

func _ready():
	# Initialize the SDK
	var init_options = EOS.Platform.InitializeOptions.new()
	init_options.product_name = "P2P Sample Game"
	init_options.product_version = "1.0"

	var init_result := EOS.Platform.PlatformInterface.initialize(init_options)
	if init_result != EOS.Result.Success:
		print("Failed to initialize EOS SDK: ", EOS.result_str(init_result))
		return
	print("Initialized EOS Platform")

	# Create platform
	var create_options = EOS.Platform.CreateOptions.new()
	create_options.product_id = ProductDetails.product_id
	create_options.sandbox_id = ProductDetails.sandbox_id
	create_options.deployment_id = ProductDetails.deployment_id
	create_options.client_id = ProductDetails.client_id
	create_options.client_secret = ProductDetails.client_secret
	create_options.encryption_key = ProductDetails.encryption_key

	var create_result = 0
	var attempt_count = 0
	while not create_result:
		#just keep going until it finally works.
		attempt_count += 1
		print("Attempt " + str(attempt_count))
		create_result = EOS.Platform.PlatformInterface.create(create_options)
		
	print("EOS Platform Created")

	# Setup Logs from EOS
	EOS.get_instance().logging_interface_callback.connect(_on_logging_interface_callback)
	var res := EOS.Logging.set_log_level(EOS.Logging.LogCategory.AllCategories, EOS.Logging.LogLevel.Info)
	if res != EOS.Result.Success:
		print("Failed to set log level: ", EOS.result_str(res))
	
	EOS.get_instance().connect_interface_login_callback.connect(_on_connect_login_callback)
	EOS.get_instance().auth_interface_login_callback.connect(_on_auth_login_callback)

func _on_logging_interface_callback(msg) -> void:
	msg = EOS.Logging.LogMessage.from(msg) as EOS.Logging.LogMessage
	print("SDK %s | %s" % [msg.category, msg.message])


func _anon_login() -> void:
	# Login using Device ID (no user interaction/credentials required)
	var opts = EOS.Connect.CreateDeviceIdOptions.new()
	opts.device_model = OS.get_name() + " " + OS.get_model_name()
	EOS.Connect.ConnectInterface.create_device_id(opts)
	await EOS.get_instance().connect_interface_create_device_id_callback

	var credentials = EOS.Connect.Credentials.new()
	credentials.token = null
	credentials.type = EOS.ExternalCredentialType.DeviceidAccessToken

	var login_options = EOS.Connect.LoginOptions.new()
	login_options.credentials = credentials
	var user_login_info = EOS.Connect.UserLoginInfo.new()
	user_login_info.display_name = "User"
	login_options.user_login_info = user_login_info
	EOS.Connect.ConnectInterface.login(login_options)

func _on_connect_login_callback(data: Dictionary) -> void:
	if not data.success:
		print("Login failed")
		EOS.print_result(data)
		gui.set_login_status_label("Login Failed")
		gui.login_status.get_node("Button").visible = true
		return
	
	local_user_id.text = data.local_user_id
	print_rich("[b]Login successfull[/b]: local_user_id=", data.local_user_id)
	gui.login_status.visible = false
	gui.main_menu.visible = true

func _on_auth_login_callback(data: Dictionary) -> void:
	if not data.success:
		print("Login failed")
		EOS.print_result(data)
		gui.set_login_status_label("Login Failed")
		gui.login_status.get_node("Button").visible = true
		return
	
	if data.local_user_id != "":
		var epic_account_id = data.local_user_id
		print("Epic Account Id: ", epic_account_id)

		var copy_user_auth_token = EOS.Auth.AuthInterface.copy_user_auth_token(EOS.Auth.CopyUserAuthTokenOptions.new(), epic_account_id)
		var token = copy_user_auth_token.token

		# Get user info of logged in user
		var options = EOS.UserInfo.QueryUserInfoOptions.new()
		options.local_user_id = epic_account_id
		options.target_user_id = epic_account_id
		EOS.UserInfo.UserInfoInterface.query_user_info(options)
		# Connect the account to get a Product User Id from the Epic Account Id
		var credentials = EOS.Connect.Credentials.new()
		credentials.token = token.access_token
		credentials.type = EOS.ExternalCredentialType.Epic
	
		var login_options = EOS.Connect.LoginOptions.new()
		login_options.credentials = credentials
		EOS.Connect.ConnectInterface.login(login_options)

func _on_login_button_pressed():
	if dev_credential_field.text.is_empty():
		return
	var credentials = EOS.Auth.Credentials.new()
	credentials.token = dev_credential_field.text
	credentials.type = EOS.Auth.LoginCredentialType.Developer
	credentials.id = "localhost:7878"
	
	var login_options = EOS.Auth.LoginOptions.new()
	login_options.credentials = credentials
	login_options.scope_flags = EOS.Auth.ScopeFlags.BasicProfile
	EOS.Auth.AuthInterface.login(login_options)


func _on_device_id_button_pressed():
	_anon_login()
