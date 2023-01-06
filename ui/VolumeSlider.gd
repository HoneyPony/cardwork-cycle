extends HSlider

export var bus_name = "Master"

var bus_idx

func _ready():
	min_value = 0
	max_value = 1
	step = 0.005
	
	bus_idx = AudioServer.get_bus_index(bus_name)
	
	value = db2linear(AudioServer.get_bus_volume_db(bus_idx))
	
	connect("value_changed", self, "update_volume")
	
func update_volume(val):
	AudioServer.set_bus_volume_db(bus_idx, linear2db(val))
