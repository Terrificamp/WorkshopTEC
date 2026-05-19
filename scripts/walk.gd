extends AudioStreamPlayer2D
@onready var stepping = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"..".velocity.x != 0 and stepping == false and $"..".is_on_floor():
		stepping = true
		$".".pitch_scale = randf_range(1.2, 1.5)
		$".".play()
		$Timer.start(0.2)
		await  $Timer.timeout
		stepping = false
	pass
