extends Camera2D

@onready var player = get_parent().get_node("Player");

func _ready():
	pass;

func _process(_delta):
	position = player.position;
