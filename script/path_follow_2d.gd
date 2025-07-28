extends PathFollow2D

@export var speed := 100 # Kecepatan gerakan
@export var steps := 5 # Jumlah langkah default jika tidak ada random_generator
@export var random_generator: Node # Node yang menghasilkan angka 

@onready var sprite = $AnimatedSprite2D

var moving = false
var target_position = Vector2.ZERO
var current_point_index = 0
var steps_to_take = 0

## Inisialisasi posisi sprite dan menghubungkan sinyal random_generator
func _ready():
	var path = get_parent().curve
	if path != null and path.get_point_count() > 0:
		global_position = path.get_point_position(0)
		current_point_index = 1 # mulai dari point ke-1 (karena sudah di point 0)
	if random_generator and random_generator.has_signal("number_generated"):
		random_generator.number_generated.connect(_on_number_generated)

## Menggerakkan sprite ke target_position setiap frame
## @param delta: Waktu antar frame
func _process(delta):
	if moving:
		var direction = (target_position - global_position).normalized()
		global_position += direction * speed * delta
		sprite.play("walk")
		if global_position.distance_to(target_position) < 5.0:
			global_position = target_position
			moving = false
			steps_to_take -= 1
			if steps_to_take > 0:
				_move_to_next_point()
	else:
		sprite.play("Idle")
		
## Menangani sinyal number_generated untuk memulai pergerakan
## @param number: Angka acak dari random_generator
func _on_number_generated(number: int):
	if not moving:
		var path = get_parent().curve
		if current_point_index < path.get_point_count():
			steps_to_take = min(number, path.get_point_count() - current_point_index)
			_move_to_next_point()

## Mengatur pergerakan ke titik berikutnya di path
func _move_to_next_point():
	var path = get_parent().curve
	if current_point_index < path.get_point_count():
		target_position = path.get_point_position(current_point_index)
		moving = true
		current_point_index += 1 
