extends Node2D

@onready var SceneTransitionAnimation = $SceneTransitionAnimation2/AnimationPlayer

var current_wave: int
@export var slime_scene: PackedScene

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended


# Called every frame. 'delta' is the elapsed time since the previous frame.



# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_first_loadin == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy
	
	current_wave = 0
	global.current_wave = current_wave
	starting_nodes = get_child_count()
	current_nodes = get_child_count() #constantly updated
	position_to_next_wave()
	
	


func position_to_next_wave():
	if current_nodes == starting_nodes:
		if current_wave != 0:
			global.moving_to_next_wave = true
		#anim
		wave_spawn_ended = false
		SceneTransitionAnimation.play("between_wave")
		current_wave += 1
		global.current_wave = current_wave
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("slime", 4.0, 4.0) #type, multiplier, spawn
		print(current_wave)

func prepare_spawn(type, multiplier, mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time: float = 2.0
	print("mob_amount: ", mob_amount)
	var mob_spawn_rounds = mob_amount/mob_spawns
	spawn_type(type, mob_spawn_rounds, mob_wait_time)

func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	if type == "slime":
		var slime_spawn1 = $spawnpoint1
		var slime_spawn2 = $spawnpoint2
		var slime_spawn3 = $spawnpoint3
		var slime_spawn4 = $spawnpoint4
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var slime1 = slime_scene.instantiate()
				slime1.global_position = slime_spawn1.global_position
				var slime2 = slime_scene.instantiate()
				slime2.global_position = slime_spawn2.global_position
				var slime3 = slime_scene.instantiate()
				slime3.global_position = slime_spawn3.global_position
				var slime4 = slime_scene.instantiate()
				slime4.global_position = slime_spawn4.global_position
				add_child(slime1)
				add_child(slime2)
				add_child(slime3)
				add_child(slime4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
			wave_spawn_ended = true

func _process(delta: float) -> void:
	change_scene()
	
	current_nodes = get_child_count()
	if wave_spawn_ended:
		position_to_next_wave()
		



func _on_cliffside_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func _on_cliffside_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			global.game_first_loadin = false
			global.finish_changescenes()
