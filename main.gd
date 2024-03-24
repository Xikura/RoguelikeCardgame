extends Node2D

var hand_size = 12

@onready var card_pile_ui := $CardPileUI
@onready var dropzones := [
	$CardDropzone_Jokers,
	$CardDropzone_Primary
]

# TODO: Move to scoring script!
var target_attack_value := 0
var starting_attack_value := 0
var current_attack_value := 0
var target_defence_value := 0
var starting_defence_value := 0
var current_defence_value := 0

var tween_duration := 0.55 #seconds

@onready var attack_power := $UserInterface/AttackPower
@onready var defence_power = $UserInterface/DefencePower

enum SortBy {
	suit,
	value
}

var current_sort = SortBy.suit

# Debug button
func _on_add_attack_button_pressed():
	add_attack(1337)

# Debug button
func _on_add_defence_button_pressed():
	add_defence(10000)

func add_attack(add_value: int):
	var target = add_value + current_attack_value
	var starting = current_attack_value
	var tween = create_tween()
	tween.tween_method(set_label_text.bind(attack_power), starting, target, tween_duration).set_delay(0.05).set_ease(Tween.EASE_IN)
	current_attack_value = target

func add_defence(add_value: int):
	var target = add_value + current_defence_value
	var starting = current_defence_value
	var tween = create_tween()
	tween.tween_method(set_label_text.bind(defence_power), starting, target, tween_duration).set_delay(0.05).set_ease(Tween.EASE_IN)
	current_defence_value = target

func set_label_text(value:int, label: Label):
	label.text = str(value)


func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready():
	randomize()
	reset()
	card_pile_ui.connect("start_scoring", start_scoring)

func reset():
	draw_cards(hand_size)

func start_scoring():
	draw_cards(hand_size - card_pile_ui._hand_pile.size())
	
	await wait_seconds(tween_duration)
	var new_scoring = 0
	var primary_dropzone: PrimaryDropzone
	var all_dropzones := []
	
	card_pile_ui._get_dropzones(get_tree().get_root(), "CardDropzone", all_dropzones)
	for dropzone in all_dropzones:
		if dropzone is PrimaryDropzone:
			primary_dropzone = dropzone
	for card in primary_dropzone.get_held_cards():
		new_scoring += card.card_data.value
	print("Adding score: ", new_scoring)
	add_attack(new_scoring)


func draw_cards(amount: int):
	card_pile_ui.draw(amount)
	sort_cards()

# Sorting
func _on_sort_by_suit_button_pressed():
	sort_cards_by_suit()
	
func _on_sort_by_value_button_pressed():
	sort_cards_by_value()
	
func sort_cards():
	if current_sort == SortBy.suit:
		sort_cards_by_suit()
	else:
		sort_cards_by_value()
	
func sort_cards_by_suit():
	current_sort = SortBy.suit
	card_pile_ui.remove_all_from_active_cards()
	card_pile_ui.sort_hand(func(a, b): 
		if a.card_data.suit == b.card_data.suit:
			return b.card_data.value < a.card_data.value
		else:
			return a.card_data.suit < b.card_data.suit
	)
	
func sort_cards_by_value():
	current_sort = SortBy.value	
	card_pile_ui.remove_all_from_active_cards()
	card_pile_ui.sort_hand(func(a, b):
		return b.card_data.value < a.card_data.value
	)

func _on_discard_active_cards_button_pressed():
	for card_ui in card_pile_ui.active_cards:
		card_pile_ui.set_card_pile(card_ui, CardPileUI.Piles.discard_pile)
	card_pile_ui.remove_all_from_active_cards()
	await wait_seconds(1) #TODO Not working?
	draw_cards(hand_size - card_pile_ui._hand_pile.size())

func _on_reset_button_pressed():
	card_pile_ui.reset()
	reset()

func _on_play_active_cards_button_pressed():
	card_pile_ui.play_active_cards()


# Example buttons below:
#func _get_rand_joker():
	#return "Black Joker" if randi_range(0, 1) else "Red Joker"
#
#func _on_discard_random_button_pressed():
	#var hand_pile_size = card_pile_ui.get_card_pile_size(CardPileUI.Piles.hand_pile)
	#if hand_pile_size:
		#var random_card_in_hand = card_pile_ui.get_card_in_pile_at(CardPileUI.Piles.hand_pile, randi() % hand_pile_size)
		#card_pile_ui.set_card_pile(random_card_in_hand, CardPileUI.Piles.discard_pile)
#
#func _on_add_joker_to_hand_button_pressed():
	#card_pile_ui.create_card_in_pile(_get_rand_joker(), CardPileUI.Piles.hand_pile)
#
#func _on_add_joker_to_discard_button_pressed():
	#card_pile_ui.create_card_in_pile(_get_rand_joker(), CardPileUI.Piles.discard_pile)
#
#func _on_random_discard_to_hand_button_pressed():
	#var discard_pile_size = card_pile_ui.get_card_pile_size(CardPileUI.Piles.discard_pile)
	#if discard_pile_size:
		#var random_card_in_discard = card_pile_ui.get_card_in_pile_at(CardPileUI.Piles.discard_pile, randi() % discard_pile_size)
		#card_pile_ui.set_card_pile(random_card_in_discard, CardPileUI.Piles.hand_pile)
#
#func _on_discard_hand_button_pressed():
	#for card_ui in card_pile_ui.get_cards_in_pile(CardPileUI.Piles.hand_pile):
		#card_pile_ui.set_card_pile(card_ui, CardPileUI.Piles.discard_pile)
#
#func _on_add_joker_to_dropzones_button_pressed():
	#for dropzone in dropzones:
		#card_pile_ui.create_card_in_dropzone(_get_rand_joker(), dropzone)
#
#func _on_move_from_dropzone_to_pile_button_pressed():
	#for dropzone in dropzones:
		#var top_card_in_dropzone = dropzone.get_top_card()
		#if top_card_in_dropzone:
			#card_pile_ui.set_card_pile(top_card_in_dropzone, CardPileUI.Piles.discard_pile)
#
#func _on_move_club_to_diamonds_pressed():
	#var clubs_dropzone = dropzones[0]
	#var top_card_in_dropzone = clubs_dropzone.get_top_card()
	#if top_card_in_dropzone:
		#var diamonds_dropzone = dropzones[1]
		#card_pile_ui.set_card_dropzone(top_card_in_dropzone, diamonds_dropzone)
#
#func _on_remove_rand_card_in_hand_from_game_pressed():
	#var hand_pile_size = card_pile_ui.get_card_pile_size(CardPileUI.Piles.hand_pile)
	#if hand_pile_size:
		#var random_card_in_hand = card_pile_ui.get_card_in_pile_at(CardPileUI.Piles.hand_pile, randi() % hand_pile_size)
		#card_pile_ui.remove_card_from_game(random_card_in_hand)
