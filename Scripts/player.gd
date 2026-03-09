extends Area2D

@onready var bullet_template = preload("res://Scenes/Bullet.tscn");

@onready var game = get_parent();
@onready var Bounds = game.get_node("Bounds");
@onready var Bullets = game.get_node("Bullets");

@export var type = "player";
@export var move_speed = 7;
@export var velocity = Vector2.ZERO;

func _ready():
	pass;

func _physics_process(delta):
	# --[ movement ]--
	var actual_move_speed = move_speed;
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	
	if (Input.is_action_pressed("slow")):
		actual_move_speed = move_speed * 0.65;
	
	if (Input.is_action_pressed("fast")):
		actual_move_speed = move_speed * 3;
	
	var move = input_vector;
	velocity += move;
	velocity *= pow(0.3, delta);
	position += velocity * actual_move_speed * delta;
	
	look_at(get_global_mouse_position())
	rotation_degrees = rotation_degrees + 270;

func _on_fire_timer_timeout():
	# fire gun
	var bullet = bullet_template.instantiate();
	#bullet.velocity = velocity.normalized() + Vector2.UP.rotated(rotation);
	bullet.position = position;
	bullet.rotation_degrees = rotation_degrees - 180;
	Bullets.add_child(bullet);
