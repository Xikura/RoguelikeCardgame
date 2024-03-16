extends CardDropzone

@export var card_type : String

func can_drop_card(card_ui : CardUI):
	print(_held_cards.size())
	return card_ui.card_data.card_type == card_type && _held_cards.size() < 5
