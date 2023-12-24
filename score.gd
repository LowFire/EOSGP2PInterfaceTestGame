extends Label

@onready var amount := $Amount

func _ready():
	GlobalData.score_changed.connect(_on_score_changed)

func _on_score_changed(score: int):
	amount.text = str(score)
