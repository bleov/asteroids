extends Area2D

@onready var collision = $CollisionShape2D;

@export var size = 50;

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = size;
	collision.shape = shape;
