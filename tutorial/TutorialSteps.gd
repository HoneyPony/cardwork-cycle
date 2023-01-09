extends Node

var marked_step = 0

var tutorial = null

var need_end_turn_button = false

func reset_all_state():
	marked_step = 0
	tutorial = null
	need_end_turn_button = false

func should_display_end_turn():
	return need_end_turn_button && (marked_step < 11)

func check_tutorial_advance():
	if not is_instance_valid(tutorial):
		tutorial = null
		return
	# Only advance the tutorial once a condition is completed AT THE
	# TIME that the condition is completed.
	if tutorial.current_line == marked_step:
		tutorial.step_tutorial()

func mark_have_planted():
	if marked_step < 5:
		marked_step = 5
		check_tutorial_advance()
	
func mark_have_watered():
	if marked_step < 7:
		marked_step = 7
		check_tutorial_advance()
		
func mark_have_defended():
	if marked_step < 9:
		marked_step = 9
		check_tutorial_advance()
	
func mark_have_ended_turn():
	if marked_step < 11:
		marked_step = 11
		check_tutorial_advance()
		
func mark_have_attacked():
	if marked_step < 13:
		marked_step = 13
		check_tutorial_advance()
