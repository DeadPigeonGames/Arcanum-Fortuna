extends Node
const musicCity = preload("res://Audio/Music/Music1.ogg")
const musicSpring = preload("res://Audio/Music/SpringSong1.ogg")
const musicWinter = preload("res://Audio/Music/MusicWinter1.ogg")

const ambienceCity = preload("res://Audio/Ambience/BackgroundAmbienceLoop1.ogg")
const ambienceSpring = preload("res://Audio/Ambience/AmbienceSpring.ogg")
const ambienceWinter = preload("res://Audio/Ambience/AmbienceWinter.ogg")

enum MapTypes { CITY, SPRING, WINTER }
@export var currentMapType:= MapTypes.CITY

var isEvenTurn = true

var musicRandom = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(currentMapType)
	_playTrack(currentMapType)


func _playTrack(currentMapType):
	randomize()
	
	var musicPlayerToChange
	var ambiencePlayerToChange
	
	if isEvenTurn:
		musicPlayerToChange = $Music
		ambiencePlayerToChange = $Ambience
	else:
		musicPlayerToChange = $Music2
		ambiencePlayerToChange = $Ambience2
	
	#currentMapType = currentMapType.keys()[randi() % currentMapType.size()]
	#print_debug(currentMapType)
	
	print_debug(currentMapType)
	
	if currentMapType == MapTypes.CITY:
		musicPlayerToChange.set_stream(musicCity)
		ambiencePlayerToChange.set_stream(ambienceCity)
	elif currentMapType == MapTypes.SPRING:
		musicPlayerToChange.set_stream(musicSpring)
		ambiencePlayerToChange.set_stream(ambienceSpring)
	elif currentMapType == MapTypes.WINTER:
		musicPlayerToChange.set_stream(musicWinter)
		ambiencePlayerToChange.set_stream(ambienceWinter)
	
	await get_tree().create_timer(0.1).timeout
	var randomMusicLoopStart = musicRandom.randf_range(0.0, musicPlayerToChange.get_stream().get_length())
	var randomAmbienceLoopStart = musicRandom.randf_range(0.0, ambiencePlayerToChange.get_stream().get_length())
	
	musicPlayerToChange.play(randomMusicLoopStart)
	ambiencePlayerToChange.play(randomAmbienceLoopStart)

func _changeMap(MapTypes):
	
	var tween = get_tree().create_tween()
	
	if isEvenTurn == true:
		tween.tween_property($Ambience, "volume_db", -80.0, 5)
		tween.tween_property($Music, "volume_db", -80.0, 5)
		_playTrack(currentMapType)
		tween.tween_property($Ambience2, "volume_db", 0.0, 5)
		tween.tween_property($Music2, "volume_db", 0.0, 5)
	else:
		tween.tween_property($Ambience2, "volume_db", -80.0, 5)
		tween.tween_property($Music2, "volume_db", -80.0, 5)
		_playTrack(currentMapType)
		tween.tween_property($Ambience, "volume_db", 0.0, 5)
		tween.tween_property($Music, "volume_db", 0.0, 5)
