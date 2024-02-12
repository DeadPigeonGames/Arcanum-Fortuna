class_name DeckPreviewCard
extends Control

var counter : Control
var label : Label
var card : Card

func setup(card_data, amount):
	label = %CopyCounterLabel
	card = %Card
	counter = %CopyCounter
	counter.visible = amount != 1
	label.text = str(amount)
	card.card_data = card_data
