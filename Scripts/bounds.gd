extends Control

const BOX_SIZE = 100;
const COLOR = Color(255, 255, 255, 1)
const WIDTH = 5;

@onready var rect = get_rect();
@onready var player = get_parent().get_node("Player");

func is_inside_bounds(pos: Vector2):
	return rect.has_point(pos);

func get_return_velocity(pos: Vector2):
	var result = Vector2.ZERO
	if pos.x > size.x / 2:
		result.x = -(pos.x - size.x / 2)
	elif pos.x < -(size.x / 2):
		result.x = -(pos.x + size.x / 2)
	if pos.y > size.y / 2:
		result.y = -(pos.y - size.y / 2)
	elif pos.y < -(size.y / 2):
		result.y = -(pos.y + size.y / 2)
	return result * 0.01

func _process(_delta):
	material.set("shader_parameter/offset", player.position);

func _draw():
	#for x in range(0, size.x, BOX_SIZE):
		#draw_line(Vector2(x, 0), Vector2(x, size.y), COLOR, WIDTH, false);
	#for y in range(0, size.y, BOX_SIZE):
		#draw_line(Vector2(0, y), Vector2(size.x, y), COLOR, WIDTH, false);
	draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0), true);
