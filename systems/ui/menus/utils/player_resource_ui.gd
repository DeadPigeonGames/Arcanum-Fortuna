class_name PlayerResourcesUI
extends UIBase

var player_data : PlayerData
var gold_label : Label
var health_label : Label
var health_bar : TextureProgressBar


func _process(delta):
	if gold_label == null or health_label == null:
		return
	update_counter()


func setup():
	await get_tree().create_timer(0.1).timeout
	player_data = Player.instance.data
	gold_label = %GoldLabel
	health_label = %HealthLabel
	health_bar = %HealthBar
	health_bar.min_value = 0
	health_bar.max_value = player_data.health


func update_counter():
	health_label.text = str(player_data.health)
	if player_data.health > health_bar.value:
		health_bar.max_value = player_data.health
	health_bar.value = player_data.health
	gold_label.text = str(player_data.currency)


func show_ui():
	show()


func hide_ui():
	hide()
