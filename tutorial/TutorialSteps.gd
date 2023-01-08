extends Node

var marked_step = 0

var need_end_turn_button = false

func should_display_end_turn():
	return need_end_turn_button && (marked_step < 11)

func mark_have_planted():
	if marked_step < 5:
		marked_step = 5
	
func mark_have_watered():
	if marked_step < 7:
		marked_step = 7
	
func mark_have_ended_turn():
	if marked_step < 11:
		marked_step = 11
