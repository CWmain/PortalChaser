extends CanvasLayer
class_name Board

# Pixel count of cell (cellSize, cellSize)
var cellSize: int = 32

# Number of cells in columns and rows (cellCount, cellCount)
var cellCount: int = 20

# The time between each tick
@export var tickTime: float = 0.5
var tickCount: int = 0
@onready var tick: Timer = $Tick

@export var chaserScene: PackedScene
@onready var chaser: Chaser = $Chaser
var chasers: Array[Chaser]

@onready var portal: Node = $portal

var score = 0

func _ready() -> void:
	tick.wait_time = tickTime
	tick.timeout.connect(_on_tick)
	chasers.append(chaser)
	portal.spawnPortal()

func gridToReal(gridPos: Vector2) -> Vector2:
	var realPos: Vector2
	realPos = gridPos*cellSize
	return realPos

func _on_tick() -> void:
	for c in chasers:
		c.updateChaserPosition()
	chaserOutOfBounds()
	chaserOnPortal()
	tickCount += 1

func chaserOutOfBounds() -> void:
	var pos: Vector2 = chasers[-1].position
	var xCheck: bool = pos.x < 0 || pos.x >= cellCount
	var yCheck: bool = pos.y < 0 || pos.y >= cellCount
	if yCheck or xCheck:
		endGame()

func chaserOnPortal() -> void:
	if chasers[-1].position == portal.position:
		chasers[-1].unactivateChaser()
		tickCount = 0
		for c in chasers:
			c.setChaserPositionToStart()
		newChaser(Vector2(portal.position))
		portal.spawnPortal()
		stopTicks() 
		score += 1
		print(score)

# Returns the time forr 1 tick to complete
func get_tick_time() -> float:
	return tickTime
	
func newChaser(spawnLoc: Vector2) -> void:
	chasers.append(chaserScene.instantiate())
	add_child(chasers[-1])
	chasers[-1].spawnChaser(spawnLoc)	

func stopTicks() -> void:
	tick.stop()
	
func startTicks() -> void:
	tick.start()

func endGame():
	print("Game is over")
