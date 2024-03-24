class_name PrimaryDropzone extends CardDropzone

@export var card_type : String

enum ActiveHandTypes {
	high_card,
	one_pair,
	two_pair,
	three_of_kind,
	house,
	flush,
	straight,
	four_of_kind,
	straight_flush,
	royal_flush,
	flush_five,
	flush_house,
	five_of_kind,
}



func _ready():
	card_pile_ui.connect("start_scoring", start_scoring)
	card_pile_ui.connect("active_cards_updated", func(cards): check_best_hand(cards))
	
func start_scoring():
	print("Start scoring...")
	
func check_best_hand(cards):
	var best_hand_text = ""
	if cards.size() == 0:
		best_hand_text = "None"
	elif is_flush_five(cards):
		best_hand_text = "Flush Five"
	elif is_flush_house(cards):
		best_hand_text = "Flush House"
	elif is_royal_straight_flush(cards):
		best_hand_text = "Royal Straight"
	elif is_straight(cards):
		best_hand_text = "Straight"
	elif is_full_house(cards):
		best_hand_text = "House"
	elif is_flush(cards):
		best_hand_text = "Flush"
	elif is_of_a_kind(cards, 5):
		best_hand_text = "Five of a Kind"
	elif is_of_a_kind(cards, 4):
		best_hand_text = "Four of a Kind"
	elif is_of_a_kind(cards, 3):
		best_hand_text = "Three of a Kind"
	elif is_pair(cards, 2):
		best_hand_text = "Two Pair"
	elif is_pair(cards, 1):
		best_hand_text = "One Pair"
	else:
		best_hand_text = "High card"
	get_node("%BestHand").text = best_hand_text

func is_pair(cards, pairs) -> bool:
	var rank_counts = {}
	for card in cards:
		if card.card_data.value in rank_counts:
			rank_counts[card.card_data.value] += 1
		else:
			rank_counts[card.card_data.value] = 1

	return rank_counts.values().count(2) == pairs

func is_royal_straight_flush(cards) -> bool:
	var ranks = []
	var suit = cards[0].card_data.suit
	for card in cards:
		if card.card_data.suit != suit:
			return false
		ranks.append(card.card_data.value)
	ranks.sort()

	return ranks == [10, 11, 12, 13, 14]

func is_flush_five(cards) -> bool:
	if cards.size() < 5:
		return false
		
	var rank_counts = {}
	var suit = cards[0].card_data.suit
	for card in cards:
		if card.card_data.suit != suit:
			return false
		if card.card_data.value in rank_counts:
			rank_counts[card.card_data.value] += 1
		else:
			rank_counts[card.card_data.value] = 1

	return rank_counts.values().count(5) == 1
	
func is_flush_house(cards) -> bool:
	if cards.size() < 5:
		return false
		
	var rank_counts = {}
	var suit_counts = {}
	for card in cards:
		if card.card_data.value in rank_counts:
			rank_counts[card.card_data.value] += 1
		else:
			rank_counts[card.card_data.value] = 1

		if card.card_data.suit in suit_counts:
			suit_counts[card.card_data.suit] += 1
		else:
			suit_counts[card.card_data.suit] = 1

	var counts = rank_counts.values()
	return counts.count(2) == 1 and counts.count(3) == 1 and suit_counts.values().count(5) == 1

func is_of_a_kind(cards, amount) -> bool:
	var rank_counts = {}
	for card in cards:
		if card.card_data.value in rank_counts:
			rank_counts[card.card_data.value] += 1
		else:
			rank_counts[card.card_data.value] = 1

	return rank_counts.values().count(4) == 1

func is_flush(cards) -> bool:
	if cards.size() < 5:
		return false
	
	var suit = cards[0].card_data.suit
	for card in cards:
		if card.card_data.suit != suit:
			return false
	return true
	
func is_straight(cards) -> bool:
	if cards.size() < 5:
		return false
	
	var ranks = []
	for card in cards:
		ranks.append(card.card_data.value)
	ranks.sort()
	
	for i in range(len(ranks) - 1):
		if ranks[i + 1] - ranks[i] != 1:
			return false
	return true

func is_full_house(cards) -> bool:
	if cards.size() < 5:
		return false
	
	var rank_counts = {}
	for card in cards:
		if card.card_data.value in rank_counts:
			rank_counts[card.card_data.value] += 1
		else:
			rank_counts[card.card_data.value] = 1

	var counts = rank_counts.values()
	return counts.count(2) == 1 and counts.count(3) == 1
