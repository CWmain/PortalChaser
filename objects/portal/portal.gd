extends Node
class_name Portal

@onready var portal_image: AnimatedSprite2D = $portalImage
var position: Vector2

var board: Board

func _ready() -> void:
	board = get_parent()

# Randomly place the portal
func spawnPortal() -> void:
	position = Vector2(randi_range(0,board.cellCount-1), randi_range(0,board.cellCount-1))
	portal_image.position = board.gridToReal(position)
	
