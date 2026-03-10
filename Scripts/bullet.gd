extends Area2D

@onready var Bounds = get_parent().get_parent().get_node("Bounds");

@export var area_type = Enum.AreaType.Projectile;
@export var velocity = Vector2.ZERO;
var move_speed = 550;

var removing = false;

func _ready():
	velocity = Vector2.RIGHT.rotated(rotation);
	position += velocity * 40

func _physics_process(delta):
	position += velocity * move_speed * delta
	
	if (!Bounds.is_inside_bounds(position) && !removing):
		removing = true;
		get_tree().create_timer(2, false).timeout.connect(func():
			if (!Bounds.is_inside_bounds(position)):
				queue_free();
			else:
				removing = false;
			)
