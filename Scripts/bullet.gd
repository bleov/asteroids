extends Area2D

@onready var Bounds = get_parent().get_parent().get_node("Bounds");

@export var type = "bullet";
@export var velocity = Vector2.ZERO;
var move_speed = 500;

func _ready():
	velocity = Vector2.UP.rotated(rotation);
	position += velocity * 40

func _physics_process(delta):
	position += velocity * move_speed * delta
	
	if (!Bounds.is_inside_bounds(position)):
		queue_free();
