extends CanvasLayer


func setup_player_data(data: PlayerData):
	$CardsOverview.player_data = data
	$CardsOverview.refresh()


func _ready():
	$CardsOverview.visible = false


func _on_toggle_cards_overview_pressed():
	$CardsOverview.visible = not $CardsOverview.visible
	$ToggleCardsOverview.text = "hide\ndeck" if $CardsOverview.visible else "show\ndeck"
	if $CardsOverview.visible:
		$CardsOverview.refresh()
