extends Node2D

@onready var parent = get_parent();
@onready var type = parent.type;
@onready var collision = parent.get_node("CollisionShape2D");

var last_draw_state = {
	"invulnerable": false,
	"spawned": false
};

var time = 0;

func _draw():
	var fill_color = Color(0, 0, 0);
	var outline_color = Color(255, 255, 255);

	if (parent.invulnerable):
		fill_color = outline_color;

	if (!parent.spawned):
		var pulse = (sin(time * TAU * 0.75) + 1.0) / 2.0 
		var alpha = int(lerp(100.0, 200.0, pulse))
		fill_color = Color.from_rgba8(150, 50, 0, alpha);
		outline_color = Color.from_rgba8(200, 50, 0, alpha);

	if (type == Enum.EnemyType.Asteroid):
		draw_circle(position, collision.shape.radius, fill_color, true)
		draw_circle(position, collision.shape.radius, outline_color, false, 5, true)

func _physics_process(delta):
	if (!parent.spawned || !last_draw_state.spawned):
		time += delta;
		queue_redraw();
		last_draw_state.spawned = parent.spawned;
	if (last_draw_state.invulnerable != parent.invulnerable):
		queue_redraw();
		last_draw_state.invulnerable = parent.invulnerable;
