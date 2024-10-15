class_name SplitAttack
extends Keyword

func init():
	super.init()


func get_new_targets(target_offsets, attacker) -> Array[int]:
	var new_offsets : Array[int]
	for target in target_offsets:
		if target == 0:
			new_offsets += [-1, 1]
	return new_offsets
