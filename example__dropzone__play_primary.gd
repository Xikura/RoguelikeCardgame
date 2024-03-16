extends CardDropzone

@export var card_type : String

func can_drop_card(card_ui : CardUI):
	print(_held_cards.size())
	return card_ui.card_data.card_type == card_type && _held_cards.size() < 5

func clicked_card(card):
	print("Card clicked!")
	print(card.card_data.nice_name)
	
	# var dropzone = card_ui.get_card_dropzone(card_ui)
	#var index = card_ui.get_index()
	#print(dropzone, index)
	#if _held_cards.size() > index:
	#	var selected_card = _held_cards[index]
	#	print(selected_card)
	#	return _held_cards[index]

func _on_card_pile_ui_card_clicked(card):
	print("Card clicked!")
	print(card.card_data.nice_name)
