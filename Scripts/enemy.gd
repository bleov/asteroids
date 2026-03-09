extends Area2D

@onready var collision = $CollisionShape2D;

const BASE_SCALE = 20;
const SCALE_FACTOR = 20;
const BASE_HEALTH = 1;
const HEALTH_SCALE_FACTOR = 5;

@export var level = 1;
@export var health = -1;
@export var max_health = -1;

func _ready():
	var size = BASE_SCALE + ((level - 1) * SCALE_FACTOR);
	var shape = CircleShape2D.new()
	shape.radius = size;
	collision.shape = shape;
	
	health =  ((level - 1) * HEALTH_SCALE_FACTOR);
	if (health == 0):
		health = BASE_HEALTH;
	max_health = health;

func _process(_delta):
	if (health <= 0):
		queue_free();

func _on_area_entered(area):
	if ("type" in area && area.type == "bullet"):
		area.queue_free();
		health -= 1;
