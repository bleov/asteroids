extends Area2D

@onready var bullet_template = preload("res://Scenes/Bullet.tscn");

@onready var game = get_parent();
@onready var Bounds = game.get_node("Bounds");
@onready var Bullets = game.get_node("Bullets");

@export var area_type: Enum.AreaType = Enum.AreaType.Player;
@export var move_speed: int = 10;
@export var velocity: Vector2 = Vector2.ZERO;
@export var state: Enum.PlayerState = Enum.PlayerState.Normal;

var dodge_cooldown = false;
var dodge_velocity = Vector2.ZERO;

const TERMINAL_VELOCITY = 1000.0;

func _ready():
	pass;

func _physics_process(delta):
	# --[ movement ]--
	var actual_move_speed = move_speed;
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	
	if (Input.is_action_pressed("dodge") && state == Enum.PlayerState.Normal && dodge_cooldown == false):
		state = Enum.PlayerState.Dodge;
		dodge_cooldown = true;
		dodge_velocity = input_vector;
		if (Input.is_action_pressed("slow")):
			dodge_velocity *= 18;
		else:
			dodge_velocity *= 25;
		Util.set_timeout(0.15, func():
			dodge_velocity = Vector2.ZERO
			state = Enum.PlayerState.Normal)
		Util.set_timeout(0.35, func():
			dodge_cooldown = false)
	
	if (Input.is_action_pressed("slow")):
		actual_move_speed = move_speed * 0.65;
	
	if (Input.is_action_pressed("fast")):
		actual_move_speed = move_speed * 3;
	
	if (state == Enum.PlayerState.Normal):
		velocity += input_vector;
		velocity *= pow(0.3, delta);
		
		# out of bounds
		var return_velocity = Bounds.get_return_velocity(position);
		velocity += return_velocity;
		
		velocity = velocity.clampf(-TERMINAL_VELOCITY, TERMINAL_VELOCITY);
		position += velocity * actual_move_speed * delta;
	elif (state == Enum.PlayerState.Dodge):
		position += dodge_velocity;
	
	look_at(get_global_mouse_position())
	rotation_degrees = rotation_degrees;

func _on_fire_timer_timeout():
	# fire gun
	if (Input.is_action_pressed("fire")): return
	var bullet = bullet_template.instantiate();
	#bullet.velocity = velocity.normalized() + Vector2.UP.rotated(rotation);
	bullet.position = position;
	bullet.rotation_degrees = rotation_degrees;
	Bullets.add_child(bullet);
