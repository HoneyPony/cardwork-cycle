extends Node2D

enum ActionType {
	ATTACK_CLOSEST
}

export var health = 3

export var actions: Array = [ActionType.ATTACK_CLOSEST]

var next_action = 0

var current_plant_target = null

var spawned = false

func _physics_process(delta):
	$HeartMarker/HealthNum.text = String(health)
	
	# If our animation is done, also check the target's animation.
	if not $AnimationPlayer.is_playing():
		if is_instance_valid(current_plant_target):
			if not current_plant_target.get_node("AnimationPlayer").is_playing():
				current_plant_target = null
				
func dec_health():
	var amount = attack_queue.pop_front()
	if amount == null:
		amount = 1
	health -= amount
	if health <= 0:
		remove_from_group("Enemy")
		remove_from_group("Object")
		$AnimationPlayer.queue("OutOfHealth")
		
var attack_queue = []
		
func take_damage(amount):
	if health <= 0:
		return
	attack_queue.push_back(amount)
	$AnimationPlayer.play("Slash")

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
	$AnimationPlayer.queue("Delay")
	
	if not spawned:
		spawned = true
		$AnimationPlayer.queue("Spawn")
		return
	
	var act = compute_action()
	
	if act == ActionType.ATTACK_CLOSEST:
		attack(find_closest())
		
func turn_over():
	if is_instance_valid(current_plant_target):
		if current_plant_target.get_node("AnimationPlayer").is_playing():
			return false
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
