extends Node2D

@onready var parent = get_parent();
@onready var type = parent.type;
@onready var collision = parent.get_node("CollisionShape2D");

var last_draw_state = {
	"invulnerable": false
};

func _draw():
	var fill_color = Color(0, 0, 0);
	var outline_color = Color(255, 255, 255);

	if (parent.invulnerable):
		fill_color = outline_color;

	if (type == Enum.EnemyType.Asteroid):
		draw_circle(position, collision.shape.radius, fill_color, true)
		draw_circle(position, collision.shape.radius, outline_color, false, 5, true)

func _process(_delta):
	if (last_draw_state.invulnerable != parent.invulnerable):
		queue_redraw();
		last_draw_state.invulnerable = parent.invulnerable;
