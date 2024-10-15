class_name TripleAttack
extends Keyword

var turns_to_skip = 1

func init():
	super.init()

func get_new_targets(target_offsets, attacker) -> Array[int]:
	var new_offsets : Array[int]
	for target in target_offsets:
		if target == 0:
			new_offsets += [-1, 0, 1]
	return new_offsets if len(new_offsets) != 0 else target_offsets
