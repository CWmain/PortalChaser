extends Node
class_name Chaser


@onready var real_position: Sprite2D = $RealPosition
@onready var visual_position: Sprite2D = $VisualPosition

var board: Board

var moveDirection: Vector2
var position: Vector2

var startingTick: int = 0
var previousPositions: Array[Vector2]

var currentTween: Tween
@export var tweenTime: float = 0.5

var active: bool = true

var up: Vector2 = Vector2(0, -1)
var down: Vector2 = Vector2(0, 1)
var left: Vector2 = Vector2(-1, 0)
var right: Vector2 = Vector2(1, 0)

# It is assumed this node has a parent which will be the board
func _ready() -> void:
	board = get_parent()
	tweenTime = board.get_tick_time()

func _process(delta: float) -> void:
	if active:
		if Input.is_action_just_pressed("moveUp"):
			moveDirection = up
		if Input.is_action_just_pressed("moveDown"):
			moveDirection = down
		if Input.is_action_just_pressed("moveLeft"):
			moveDirection = left
		if Input.is_action_just_pressed("moveRight"):
			moveDirection = right
		if moveDirection:
			if board.tick.paused:
				board.resumeTicks()

func spawnChaser(spawnLocation: Vector2) -> void:
	killActiveTween()
	position = spawnLocation
	previousPositions.append(position)
	var real: Vector2 = gridToReal(position)
	visual_position.position = real
	real_position.position = real

func setChaserPositionToStart() -> void:
	killActiveTween()
	position = previousPositions[0]
	var real: Vector2 = gridToReal(position)
	visual_position.position = real
	real_position.position = real
	

# Called on game tick and moves the chaser in the moveDirection
func updateChaserPosition() -> void:
	if active:
		activeChaserMovement()
	else:
		oldChaserMovement()

func activeChaserMovement() -> void:
	killActiveTween()
	
	faceDirection()
	
	# Update position with moveDirection and get the real position from board
	position = position + moveDirection
	previousPositions.append(position)
	animateMovementToPosition()

	

func oldChaserMovement() -> void:
	killActiveTween()
	
	faceDirection()
	
	# Since I want to allow forr later spawning in, adjust the board tick to a relative tick
	var relativeTick: int = board.tickCount - startingTick
	if relativeTick >= len(previousPositions) or relativeTick < 0:
		return

	position = previousPositions[relativeTick]
	animateMovementToPosition()
	
	

func animateMovementToPosition() -> void:
	var real: Vector2 = gridToReal(position)
	currentTween = create_tween()
	currentTween.tween_property(visual_position, "position", real, tweenTime)
	real_position.position = real


func gridToReal(gridPosition: Vector2) -> Vector2:
	return board.gridToReal(gridPosition) + Vector2(16,16)

# Rotate visualPosition to be facing the move direction
func faceDirection() -> void:
	match moveDirection:
		up:
			visual_position.rotation = 0
		down:
			visual_position.rotation = PI
		right:
			visual_position.rotation = PI/2
		left:
			visual_position.rotation = 3*PI/2
		# Default
		_:
			visual_position.rotation = 0

func killActiveTween() -> void:
	if currentTween != null and currentTween.is_running():
		currentTween.kill()

func unactivateChaser() -> void:
	active = false
	visual_position.self_modulate = Color.DARK_SLATE_GRAY
