extends Panel

onready var tween = $Tween
onready var button = $HideShow

signal open_start
signal close_start
signal close_finish
signal open_finish
signal toggled

#####################################
## EXPORT

export (int) var height_open = 200
export (float) var open_speed = 1
export (float) var close_speed = 1

enum Direction {TOP=0, DOWN=1}
export (Direction) var expand_direction = Direction.DOWN

export(int, "EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN") var open_ease_type = Tween.EASE_OUT
export(int, "TRANS_LINEAR", "TRANS_SINE", "TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", "TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", "TRANS_CIRC", "TRANS_BOUNCE", "TRANS_BACK") var open_transition_type = Tween.TRANS_BOUNCE
export(int, "EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN") var close_ease_type = Tween.EASE_OUT
export(int, "TRANS_LINEAR", "TRANS_SINE", "TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", "TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", "TRANS_CIRC", "TRANS_BOUNCE", "TRANS_BACK") var close_transition_type = Tween.TRANS_BOUNCE

export(String) var closed_button_string = ""
export(String) var opened_button_string = ""

export (bool) var is_closed = true

#####################################
## INTERNAL
var switch = true #true when state is closed

var start_position_y 
var start_size_y 
var end_position_y
var end_size_y 

func _ready():
	start_position_y = rect_position.y
	if expand_direction == Direction.TOP:
		end_position_y = rect_position.y - height_open
		start_size_y = rect_size.y
		end_size_y = rect_size.y - height_open
	else:
		end_position_y = rect_position.y 
		start_size_y = rect_size.y
		end_size_y = rect_size.y + height_open

	if is_closed:
		rect_size.y = 0
		if(closed_button_string != ""):
			button.text = closed_button_string
	else:
		tween_start()
		tween.seek(open_speed)
		if(opened_button_string != ""):
			button.text = opened_button_string

func tween_start():
	if switch:
		if expand_direction == Direction.TOP:
			button.anchor_top = 0
			button.anchor_bottom = 0
			tween.interpolate_property(self, "rect_position:y",
			rect_position.y, end_position_y, open_speed,
			open_transition_type, open_ease_type)
			
		else:
			button.anchor_top = 1
			button.anchor_bottom = 1
					
		tween.interpolate_property(self, "rect_size:y",
		rect_size.y, end_size_y, open_speed,
		open_transition_type, open_ease_type)
		tween.start()

	else:
		if expand_direction == Direction.TOP:
			tween.interpolate_property(self, "rect_position:y",
				rect_position.y, start_position_y, close_speed,
				close_transition_type, close_ease_type)
		tween.interpolate_property(self, "rect_size:y",
			rect_size.y, start_size_y, close_speed,
			close_transition_type, close_ease_type)
		tween.start()

	switch = !switch

func toggle():
	emit_signal("toggled")
	tween.stop_all()
	if switch:
		emit_signal("open_start")
		tween_start()
		if(opened_button_string != ""):
			button.text = opened_button_string
	else:
		emit_signal("close_start")
		tween_start()
		if(closed_button_string != ""):
			button.text = closed_button_string

func _on_HideShow_pressed():
	toggle()


func _on_Tween_tween_completed(object, key):
	if switch:
		emit_signal("close_finish")
	else:
		emit_signal("open_finish")
