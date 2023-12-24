extends HBoxContainer

@onready var nat_type_label: RichTextLabel = $NATTypeLabel

func _ready():
	EOS.get_instance().p2p_interface_query_nat_type_callback.connect(_on_query_nat_type_complete)
	EOS.get_instance().connect_interface_login_callback.connect(_on_connect_interface_login)
	
func _on_connect_interface_login(data: Dictionary) -> void:
	EOS.P2P.P2PInterface.query_nat_type()

func _on_query_nat_type_complete(nat_type: EOS.P2P.NATType) -> void:
	match nat_type:
		EOS.P2P.NATType.Open:
			nat_type_label.text = "[color=green]Open[/color]"
		EOS.P2P.NATType.Moderate:
			nat_type_label.text = "[color=yellow]Moderate[/color]"
		EOS.P2P.NATType.Strict:
			nat_type_label.text = "[color=red]Strict[/color]"
		_:
			nat_type_label.text = "[color=black]Unknown[/color]"
