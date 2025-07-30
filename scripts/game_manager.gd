extends Node

# --- PENGATURAN PAPAN PERMAINAN ---
const BOARD_SIZE = 100 # Jumlah total kotak di papan

# Ini adalah jantung dari mekanisme Ular Tangga kita.
var special_tiles = {
	# Contoh Tangga (naik)
	4: 14,
	9: 31,
	20: 38,
	28: 84,
	40: 59,
	51: 67,
	63: 81,
	71: 91,
	# Contoh Ular (turun)
	17: 7,
	54: 34,
	62: 19,
	64: 60,
	87: 24,
	93: 73,
	95: 75,
	99: 78
}

@export var player_nodes: Array[AnimatedSprite2D]

var player_positions: Array[int] = [1, 1, 1, 1] # Saving each player's position
var current_player_index: int = 0 # Current player's index
var game_over: bool = false

# Visual coordinate
var tile_coordinates: Array = [
	null, 
	Vector2(318.0, 583.0), Vector2(375.0, 583.0), Vector2(433.0, 583.0), Vector2(491.0, 583.0), Vector2(547.0, 583.0), 
	Vector2(605.0, 583.0), Vector2(662.0, 583.0), Vector2(719.0, 583.0), Vector2(777.0, 583.0), Vector2(836.0, 583.0), 
	Vector2(836.0, 525.0), Vector2(777.0, 525.0), Vector2(720.0, 525.0), Vector2(662.0, 525.0), Vector2(605.0, 525.0), 
	Vector2(546.0, 525.0), Vector2(489.0, 525.0), Vector2(431.0, 525.0), Vector2(373.0, 525.0), Vector2(316.0, 525.0), 
	Vector2(316.0, 467.0), Vector2(375.0, 467.0), Vector2(432.0, 467.0), Vector2(489.0, 467.0), Vector2(548.0, 467.0), 
	Vector2(605.0, 467.0), Vector2(662.0, 467.0), Vector2(720.0, 467.0), Vector2(777.0, 467.0), Vector2(834.0, 467.0), 
	Vector2(834.0, 410.0), Vector2(777.0, 410.0), Vector2(720.0, 410.0), Vector2(662.0, 410.0), Vector2(605.0, 410.0), 
	Vector2(547.0, 410.0), Vector2(489.0, 410.0), Vector2(432.0, 410.0), Vector2(375.0, 410.0), Vector2(316.0, 410.0), 
	Vector2(316.0, 353.0), Vector2(374.0, 353.0), Vector2(432.0, 353.0), Vector2(489.0, 353.0), Vector2(548.0, 353.0), 
	Vector2(605.0, 353.0), Vector2(662.0, 353.0), Vector2(720.0, 353.0), Vector2(778.0, 353.0), Vector2(834.0, 353.0), 
	Vector2(834.0, 295.0), Vector2(776.0, 295.0), Vector2(718.0, 295.0), Vector2(661.0, 295.0), Vector2(603.0, 295.0), 
	Vector2(546.0, 295.0), Vector2(489.0, 295.0), Vector2(431.0, 295.0), Vector2(374.0, 295.0), Vector2(317.0, 295.0), 
	Vector2(317.0, 238.0), Vector2(374.0, 238.0), Vector2(431.0, 238.0), Vector2(489.0, 238.0), Vector2(547.0, 238.0), 
	Vector2(604.0, 238.0), Vector2(662.0, 238.0), Vector2(719.0, 238.0), Vector2(777.0, 238.0), Vector2(835.0, 238.0), 
	Vector2(835.0, 180.0), Vector2(775.0, 180.0), Vector2(719.0, 180.0), Vector2(660.0, 180.0), Vector2(604.0, 180.0), 
	Vector2(546.0, 180.0), Vector2(489.0, 180.0), Vector2(432.0, 180.0), Vector2(373.0, 180.0), Vector2(316.0, 180.0), 
	Vector2(316.0, 124.0), Vector2(374.0, 124.0), Vector2(432.0, 124.0), Vector2(489.0, 124.0), Vector2(546.0, 124.0), 
	Vector2(604.0, 124.0), Vector2(660.0, 124.0), Vector2(719.0, 124.0), Vector2(775.0, 124.0), Vector2(834.0, 124.0), 
	Vector2(834.0, 67.0), Vector2(778.0, 67.0), Vector2(719.0, 67.0), Vector2(660.0, 67.0), Vector2(605.0, 67.0), 
	Vector2(546.0, 67.0), Vector2(489.0, 67.0), Vector2(432.0, 67.0), Vector2(374.0, 67.0), Vector2(316.0, 67.0)
]
# References to UI
@onready var turn_info_label = $"/root/Main_game/UI/Turn_info_label"
@onready var roll_dice_button = $"/root/Main_game/UI/Roll_dice_button"

func _ready():
	#set all of the player's position into first box
	for i in range(player_nodes.size()):
		player_nodes[i].position = tile_coordinates[1]
		player_nodes[i].play("idle")

	roll_dice_button.pressed.connect(_on_roll_dice_button_pressed)
	start_turn()

func start_turn():
	if game_over:
		return

	turn_info_label.text = "Giliran Pemain %d" % (current_player_index + 1)
	roll_dice_button.disabled = false

func _on_roll_dice_button_pressed():
	if game_over:
		return
	
	roll_dice_button.disabled = true
	
	# 1. Lempar dadu
	var dice_result = randi_range(1, 6)
	var current_pos = player_positions[current_player_index]
	var new_pos = current_pos + dice_result
	
	print("Pemain %d (di kotak %d) melempar dadu: %d" % [current_player_index + 1, current_pos, dice_result])

	# 2. Aturan Kemenangan: Harus pas di kotak terakhir
	if new_pos > BOARD_SIZE:
		# Jika lemparan melebihi kotak 100, pemain tetap di tempat.
		print("Terlalu jauh! Pemain %d tetap di kotak %d" % [current_player_index + 1, current_pos])
		next_turn()
		return
	elif new_pos == BOARD_SIZE:
		# Pemain menang!
		player_positions[current_player_index] = new_pos
		move_player_sprite(new_pos)
		
		game_over = true
		turn_info_label.text = "Pemain %d MENANG!" % (current_player_index + 1)
		## player_nodes[current_player_index].play("celebrate") # Animasi kemenangan
		print("Pemain %d MENANG!" % (current_player_index + 1))
		return

	# 3. Pengecekan Ular dan Tangga
	if special_tiles.has(new_pos):
		var final_pos = special_tiles[new_pos]
		player_positions[current_player_index] = final_pos
		if final_pos > new_pos:
			print("Naik Tangga! Dari %d ke %d" % [new_pos, final_pos])
			# Di sini Anda bisa menambahkan SFX atau animasi khusus tangga
		else:
			print("Turun Ular! Dari %d ke %d" % [new_pos, final_pos])
			# Di sini Anda bisa menambahkan SFX atau animasi khusus ular
		move_player_sprite(final_pos)
	else:
		# Pergerakan normal
		player_positions[current_player_index] = new_pos
		move_player_sprite(new_pos)
	
	# 4. Pindah ke giliran selanjutnya
	await get_tree().create_timer(0.5).timeout # Beri jeda sedikit sebelum ganti giliran
	next_turn()

func move_player_sprite(target_tile_number):
	var player_node = player_nodes[current_player_index]
	var target_position = tile_coordinates[target_tile_number]
	
	player_node.play("walk")
	var tween = create_tween()
	tween.tween_property(player_node, "position", target_position, 0.8).set_trans(Tween.TRANS_SINE)
	await tween.finished
	player_node.play("idle")
	
func next_turn():
	# Set pemain saat ini ke idle sebelum ganti
	player_nodes[current_player_index].play("idle")
	current_player_index = (current_player_index + 1) % player_nodes.size()
	start_turn()
