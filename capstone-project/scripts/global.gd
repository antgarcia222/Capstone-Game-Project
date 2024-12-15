extends Node

var player_current_attack = false

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_posx = 396
var player_exit_cliffside_posy = 18
var player_start_posx = 155
var player_start_posy = 180

var game_first_loadin = true

var current_wave: int
var moving_to_next_wave: bool


func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
