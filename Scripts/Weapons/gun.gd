extends Node2D

var bullet_template = preload("res://Scenes/Bullet.tscn");

@onready var game: Node2D = $/root/Game;
@onready var player: Area2D = game.get_node("Player");
@onready var Bullets: Node = game.get_node("Bullets");

func _on_fire_timer_timeout():
	# fire gun
	if (Input.is_action_pressed("fire")): return
	var bullet = bullet_template.instantiate();
	bullet.position = position;
	bullet.rotation_degrees = rotation_degrees;
	Bullets.add_child(bullet);
