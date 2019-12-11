extends Panel

onready var tween = $Tween
onready var button = $HideShow

export (int) var height_window = 200
export (float) var speed_window_open = 1
export (float) var speed_window_close = 1

enum Direction {TOP=0, DOWN=1}
export (Direction) var expand_direction = Direction.DOWN

export(int, "EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN") var ease_type_open = Tween.EASE_OUT
export(int, "TRANS_LINEAR", "TRANS_SINE", "TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", "TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", "TRANS_CIRC", "TRANS_BOUNCE", "TRANS_BACK") var transition_type_open = Tween.TRANS_BOUNCE
export(int, "EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN") var ease_type_close = Tween.EASE_OUT
export(int, "TRANS_LINEAR", "TRANS_SINE", "TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", "TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", "TRANS_CIRC", "TRANS_BOUNCE", "TRANS_BACK") var transition_type_close = Tween.TRANS_BOUNCE

export(String) var closed_button_string = ""
export(String) var opened_button_string = ""

export (bool) var is_closed = true
var switch = true #true when state is closed

func _ready():
	if is_closed:
		rect_size.y = 0
		if(closed_button_string != ""):
			button.text = closed_button_string
	else:
		tween_start()
		tween.seek(speed_window_open)
		if(opened_button_string != ""):
			button.text = opened_button_string

func tween_start():
	if switch:
		if expand_direction == Direction.TOP:
			button.anchor_top = 0
			button.anchor_bottom = 0
			tween.interpolate_property(self, "rect_position:y",
			rect_position.y, rect_position.y - (height_window), speed_window_open,
			transition_type_open, ease_type_open)
			pass
		else:
			button.anchor_top = 1
			button.anchor_bottom = 1
			pass
		
		tween.interpolate_property(self, "rect_size:y",
		rect_size.y, rect_size.y + (height_window), speed_window_open,
		transition_type_open, ease_type_open)
		tween.start()
		pass
	else:
		if expand_direction == Direction.TOP:
			tween.interpolate_property(self, "rect_position:y",
				self.rect_position.y, self.rect_position.y + height_window, speed_window_close,
				transition_type_close, ease_type_close)
		tween.interpolate_property(self, "rect_size:y",
			self.rect_size.y, self.rect_size.y - height_window, speed_window_close,
			transition_type_open, ease_type_close)
		tween.start()
		pass

	switch = !switch
	pass

func _on_HideShow_pressed():
	if switch:
		tween_start()
		if(opened_button_string != ""):
			button.text = opened_button_string
	else:
		tween_start()
		if(closed_button_string != ""):
			button.text = closed_button_string
