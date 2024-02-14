class_name PlayerResourcesUI
extends UIBase

var player_data : PlayerData
var gold_label : Label
var health_label : Label


func _process(delta):
	if gold_label == null or health_label == null:
		return
	update_counter()
	visible = SceneHandler.combat == null
	# I know this is bad, but Week 10
	# Please do not kill me, I am little good boy,
	# take care of me, need food
	# (will be changed)


func setup():
	await get_tree().process_frame
	player_data = Player.instance.data
	gold_label = %GoldLabel
	health_label = %HealthLabel


func update_counter():
	health_label.text = str(player_data.health)
	gold_label.text = str(player_data.currency)
