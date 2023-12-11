class_name CombatPhaseTrigger
extends Resource

enum SourcePhases {
	NONE,
	TURN_START, 
	FRIENDLY_PLACEMENT,
	FRIENDLY_ATTACKS, 
	FRIENDLY_KARMA,
	ENEMY_MOVEMENT,
	ENEMY_ATTACKS,
	TURN_END,
}

enum Timings {
	STARTED,
	FINISHED,
}

@export var source_phase := SourcePhases.TURN_START
@export var timing := Timings.STARTED
