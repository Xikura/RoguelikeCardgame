extends CardUI

@onready var label := $Frontface/Label

func _ready():
	super()
	label.text = card_data.nice_name
	# is_active = false

# func _on_card_active(card):
	#active_position = target_position
	#active_position.y -= 55
	#target_position.y -= 55
	# print("Card is now active?", is_active)
	#position -= Vector2(0, 55).rotated(rotation)

# func _on_card_inactive(card):
	#active_position = target_position
	#active_position.y += 55
	# print("Card is now inactive", is_active)
	#position += Vector2(0, 55).rotated(rotation)

func _process(_delta):
	#if is_active:
		#target_position = active_position
	#if is_clicked and drag_when_clicked:
	#	target_position = get_global_mouse_position() - custom_minimum_size * 0.5
	if is_active:
		position = active_position
	elif is_clicked:
		position = target_position
	elif position != target_position:
		position = lerp(position, target_position, return_speed)
