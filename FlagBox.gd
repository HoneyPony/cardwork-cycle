extends CheckBox

export var item = 1

func _ready():
	if item == 1:
		pressed = Flags.skip_tutorial
	if item == 2:
		pressed = Flags.hard_mode

func _process(delta):
	if item == 1:
		Flags.skip_tutorial = pressed
	if item == 2:
		Flags.hard_mode = pressed
