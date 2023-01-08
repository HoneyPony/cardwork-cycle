extends Node2D

enum ActionType {
	ATTACK_CLOSEST
}

export var actions: Array = [ActionType.ATTACK_CLOSEST]

var next_action = 0

var current_plant_target = null

func pull_action():
	var result = actions[next_action]
	
	next_action += 1
	if next_action >= actions.size():
		next_action = 0
		
	return result

func compute_action():
	var op = actions[next_action]
	
	# Here we can implement some branching logic... basically a very
	# simple bytecode... if we want more complex enemy behaviors.
	
	return op

func take_turn():
	var act = compute_action()
	
	if act == ActionType.ATTACK_CLOSEST:
		attack(find_closest())
		
func turn_over():
	return not $AnimationPlayer.is_playing()
	
func attack(plant):
	if not is_instance_valid(plant):
		return
	
	$AnimationPlayer.play("Attack")
	current_plant_target = plant
	
func play_target_anim():
	current_plant_target.get_node("AnimationPlayer").play("Slash")
	
func find_closest():
	var closest = null
	var dist = 0
	for plant in get_tree().get_nodes_in_group("Plant"):
		if closest == null:
			closest = plant
			dist = (plant.position - position).length()
		else:
			var test = (plant.position - position).length()
			if test < dist:
				closest = plant
				dist = test
	return closest
	
func finalize_turn():
	pass
