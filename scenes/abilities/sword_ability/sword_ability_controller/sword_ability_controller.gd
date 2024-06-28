extends Node

@export var max_range = 150
@export var sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect to timeout node
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
#region Check Player existence
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
#endregion

#region Ability Behaviour towards Enemy
	#get Enemies
	var enemies = get_tree().get_nodes_in_group("enemies")
	#filters enemies within Max Range of player
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
	)
	
	#check if Enemies exist
	if enemies.size() == 0:
		return

	#get closest Enemy to Player
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
#endregion
#region Ability Positioning
	#position of ability spawn
	var sword_instance = sword_ability.instantiate() as Node2D
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemies[0].global_position
	#offsets the ability randomly around Enemy
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	#rotation of ability spawn
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
#endregion
