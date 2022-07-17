extends ScrollContainer

export (NodePath) var data_consumer_path : NodePath

onready var data_consumer := get_node(data_consumer_path) as DataConsumer

var looping = true
var duration_seconds := 5.0

func generate(params : Dictionary) -> void:
	# generate the scroll data
	pass

func play(reset = true) -> void:
	# play the animation, looping if set to
	pass
