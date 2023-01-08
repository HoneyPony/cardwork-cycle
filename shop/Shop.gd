extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func contains_mouse(control: Control):
	var r = Rect2(Vector2.ZERO, control.rect_size)
	return r.has_point(control.get_local_mouse_position())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	GS.shop_open = visible
	
	var new_text = ""
	for item in $Items.get_children():
		if contains_mouse(item) or contains_mouse(item.get_node("Button")):
			new_text = item.description
			if item.bought:
				new_text += " (bought)"
			
	$Desc.text = new_text


func _on_DoneButton_pressed():
	$AnimationPlayer.play("Popdown")


func _on_ShopButton_pressed():
	$AnimationPlayer.play("Popup")
