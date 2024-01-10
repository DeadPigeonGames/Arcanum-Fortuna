class_name EnemyData
extends Resource

@export var brain : EnemyBrain

@export_category("Stats")
@export var stats_per_level : Array[EnemyBrainStats]
@export var gold_reward := 4

@export_category("Debug")
@export var level = 0

var rng_seed := -1


func init():
	if level >= stats_per_level.size():
		push_warning("Enemy Level was set to ", str(level), \
			" but no stats are set above level ", stats_per_level.size() - 1, ".")
		level = stats_per_level.size() - 1


func get_random_health():
	return brain.get_random_health()


func setup_brain(owner : EnemyPlayer, combat : CardBattle):
	brain.init(stats_per_level[level], owner, combat, rng_seed)


func increase_level():
	if level == stats_per_level.size() - 1:
		push_warning("Level Up has no effect: Enemy is already at max level.")
		return
	level += 1
