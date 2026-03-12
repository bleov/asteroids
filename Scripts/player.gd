extends Area2D

@onready var game: Node2D = get_parent();
@onready var Bounds: Control = game.get_node("Bounds");
@onready var LevelUp: Control = game.get_node("UI/LevelUp");
@onready var Weapons: Node2D = $Weapons;

@onready var DashSound = $DashSound;
@onready var Dash2Sound = $Dash2Sound;
@onready var HurtSound = $HurtSound;
@onready var LevelUpSound = LevelUp.get_node("LevelUpSound");

@export var area_type: Enum.AreaType = Enum.AreaType.Player;
@export var move_speed: int = 10;
@export var velocity: Vector2 = Vector2.ZERO;
@export var state: Enum.PlayerState = Enum.PlayerState.Normal;
@export var health: int = 5;
@export var max_health: int = 5;
@export var xp: int = 0;
@export var max_xp: int = 20;

var dodge_cooldown = false;
var dodge_velocity = Vector2.ZERO;

const TERMINAL_VELOCITY = 1000.0;

func _ready():
	pass;

func _physics_process(delta):
	# --[ movement ]--
	var actual_move_speed = move_speed;
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	
	if (Input.is_action_pressed("dodge") && state == Enum.PlayerState.Normal && dodge_cooldown == false && input_vector != Vector2.ZERO):
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
		if (randf() < 0.5):
			DashSound.play();
		else:
			Dash2Sound.play();
	
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

	# weird hack
	Weapons.position = position;
	for weapon in Weapons.get_children():
		weapon.position = position;
		weapon.rotation = rotation;

func update_health(amount: int):
	health = clamp(health + amount, 0, max_health);
	game.update_health_display();

func damage(amount: int):
	update_health(-amount);
	HurtSound.play();

func earn(amount: int):
	xp += amount;
	game.update_xp_display();
	if (xp >= max_xp):
		level_up();

func level_up():
	xp = 0;
	max_xp += 10;
	game.update_xp_display();
	LevelUpSound.play();
	get_tree().paused = true;
	LevelUp.visible = true;
