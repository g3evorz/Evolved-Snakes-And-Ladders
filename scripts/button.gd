extends Button

signal number_generated(number: int) # Sinyal untuk mengirim angka acak
var random_number: int = 0 # Angka acak yang dihasilkan (1-6)

## Menghubungkan sinyal pressed saat tombol dimuat
func _ready():
	pressed.connect(_on_button_pressed)

## Menghasilkan angka acak 1-6 saat tombol ditekan
func _on_button_pressed():
	random_number = randi_range(3, 3)	
	number_generated.emit(random_number)

## Mengembalikan angka acak yang dihasilkan
## @return: Angka acak dari 1 hingga 6
func get_random_number() -> int:
	return random_number
