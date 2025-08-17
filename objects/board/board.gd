extends CanvasLayer
class_name Board

# Pixel count of cell (cellSize, cellSize)
var cellSize: int = 32

# Number of cells in columns and rows (cellCount, cellCount)
var cellCount: int = 20

@export var tickTime: float = 0.5

@onready var tick: Timer = $Tick
@onready var chaser: Chaser = $Chaser

func _ready() -> void:
	tick.wait_time = tickTime
	tick.timeout.connect(_on_tick)

func gridToReal(gridPos: Vector2) -> Vector2:
	var realPos: Vector2
	realPos = gridPos*cellSize
	return realPos

func _on_tick() -> void:
	chaser.updateChaserPosition()

# Returns the time forr 1 tick to complete
func get_tick_time() -> float:
	return tickTime
	
