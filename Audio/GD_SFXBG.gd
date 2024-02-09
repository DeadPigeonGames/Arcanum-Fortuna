extends Node
const musicCity = preload("res://Audio/Music/Music1.ogg")
const musicSpring = preload("res://Audio/Music/SpringSong1.ogg")
const musicWinter = preload("res://Audio/Music/MusicWinter1.ogg")

const ambienceCity = preload("res://Audio/Ambience/BackgroundAmbienceLoop1.ogg")
const ambienceSpring = preload("res://Audio/Ambience/AmbienceSpring.ogg")
const ambienceWinter = preload("res://Audio/Ambience/AmbienceWinter.ogg")

enum mapTypes { CITY, SPRING, WINTER }
@export var currentMapType: mapTypes 

var isEvenTurn


var musicRandom = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_playTrack(currentMapType)

func _changeMap(mapTypes):
	
	var tween = get_tree().create_tween()
	
	if isEvenTurn == true:
		tween.tween_property($Ambience, "volume_db", -80.0, 5)
		tween.tween_property($Music, "volume_db", -80.0, 5)
		
		tween.tween_property($Ambience2, "volume_db", 0.0, 5)
		tween.tween_property($Music2, "volume_db", 0.0, 5)
	else:
		tween.tween_property($Ambience, "volume_db", -80.0, 5)
		tween.tween_property($Music, "volume_db", -80.0, 5)

func _playTrack(mapTypes):
	randomize()
	
	#currentMapType = currentMapType.keys()[randi() % currentMapType.size()]
	#print_debug(currentMapType)
	
	#if currentMapType == mapTypes.CITY:
		#$Music.set_stream(musicCity)
		#$Ambience.set_stream(ambienceCity)
	#elif currentMapType == mapTypes.SPRING:
		#$Music.set_stream(musicSpring)
		#$Ambience.set_stream(ambienceSpring)
	#elif currentMapType == mapTypes.WINTER:
		#$Music.set_stream(musicWinter)
		#$Ambience.set_stream(ambienceWinter)
	
	
	
	await get_tree().create_timer(0.1).timeout
	var randomMusicLoopStart = musicRandom.randf_range(0.0, $Music.get_stream().get_length())
	var randomAmbienceLoopStart = musicRandom.randf_range(0.0, $Ambience.get_stream().get_length())
	
	$Music.play(randomMusicLoopStart)
	$Ambience.play(randomAmbienceLoopStart)
