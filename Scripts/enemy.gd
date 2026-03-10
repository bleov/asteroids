extends Area2D

@onready var collision = $CollisionShape2D;
@onready var DrawNode = $Draw;
@onready var Bounds = $/root/Game/Bounds;
@onready var Enemies = $/root/Game/Enemies;
@onready var HitSound = $HitSound;
@onready var KillSound = $KillSound;

var enemy_template = preload("res://Scenes/Enemy.tscn");

const BASE_SCALE = 20;
const SCALE_FACTOR = 20;
const BASE_HEALTH = 1;
const HEALTH_SCALE_FACTOR = 5;
const TERMINAL_VELOCITY = 1000.0;
const MINIMUM_VELOCITY = 5.0;

@export var area_type: Enum.AreaType = Enum.AreaType.Enemy;
@export var type: Enum.EnemyType = Enum.EnemyType.Asteroid;
@export var level: int = 1;
@export var health: int = -1;
@export var max_health: int = -1;
@export var velocity: Vector2 = Vector2.ZERO;
@export var is_child: bool = false;
@export var invulnerable: bool = false;
@export var spawned: bool = false;
@export var died = false;

var move_speed = 10;
var starting_velocity = 5;

func _ready():
	health = level;
	max_health = health;
	
	var size = BASE_SCALE + ((level - 1) * SCALE_FACTOR);
	var shape = CircleShape2D.new()
	shape.radius = size;
	collision.shape = shape;
	
	starting_velocity = randf_range(MINIMUM_VELOCITY, 10.0);
	velocity = Vector2(starting_velocity, 0).rotated(randf_range(0.0, 360.0));
	
	if (is_child):
		spawned = true
		collision.disabled = false
	else:
		Util.set_timeout(3, func():
			spawned = true
			collision.disabled = false);

func kill():
	KillSound.play();
	collision.disabled = true;
	DrawNode.visible = false;
	Util.set_timeout(0.5, func():
		queue_free());

func _physics_process(delta):
	if (!ready || !spawned): return
	if (health <= 0 && died == false):
		died = true;
		kill();
		if (type == Enum.EnemyType.Asteroid && level > 1):
			for i in 2:
				var enemy = enemy_template.instantiate();
				enemy.level = level - 1;
				enemy.type = type;
				enemy.position = position;
				enemy.is_child = true;
				Enemies.add_child(enemy);
	
	velocity *= pow(0.9, delta);
	
	var return_velocity = Bounds.get_return_velocity(position);
	velocity += return_velocity;
	
	# Restart stopped asteroids
	velocity = velocity.clampf(-TERMINAL_VELOCITY, TERMINAL_VELOCITY);
	if (velocity < Vector2(1, 1) && velocity > Vector2(0, 0)):
		velocity += Vector2(0.01, 0.01);
	if (velocity > Vector2(-1, -1) && velocity < Vector2(0, 0)):
		velocity -= Vector2(0.01, 0.01);
	
	position += velocity * move_speed * delta;

func _on_area_entered(area):
	if (area.area_type == Enum.AreaType.Projectile):
		area.queue_free();
		if (!invulnerable):
			health -= 1;
			if (health > 1):
				HitSound.play();
	if (area.area_type == Enum.AreaType.Player):
		velocity += area.velocity;
		area.velocity = -area.velocity / 2;
