extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction: Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

const RIGHT_INPUT = "right"
const LEFT_INPUT = "left"
const DOWN_INPUT = "down"
const UP_INPUT = "up"
const IDLE_BLEND_POSITION = "parameters/Idle/blend_position"
const WALK_BLEND_POSITION = "parameters/Walk/blend_position"

func _ready():
	animation_tree.set(IDLE_BLEND_POSITION, starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength(RIGHT_INPUT) - Input.get_action_strength(LEFT_INPUT),
		Input.get_action_strength(DOWN_INPUT) - Input.get_action_strength(UP_INPUT)
	)
	
	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set(IDLE_BLEND_POSITION, move_input)
		animation_tree.set(WALK_BLEND_POSITION, move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
