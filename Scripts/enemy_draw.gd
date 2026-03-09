extends Node2D

@onready var collision = get_parent().get_node("CollisionShape2D");

const FILL_COLOR = Color(0, 0, 0);
const OUTLINE_COLOR = Color(255, 255, 255);

func _draw():
	draw_circle(position, collision.shape.radius, FILL_COLOR, true)
	draw_circle(position, collision.shape.radius, OUTLINE_COLOR, false, 5, true)
	queue_redraw();
