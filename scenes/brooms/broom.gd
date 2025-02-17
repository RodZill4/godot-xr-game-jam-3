extends Node3D

@export var broom_name : String
@export var broom_music : AudioStream


@export var maximum_speed : float = 10.0
@export var rotation_speed : float = 2.0
@export var vertical_speed : float = 1.0
@export var decay : float = 200.0
@export var lean_amount : float = 0.1

@onready var handle : Node3D = $HandleOrigin/InteractableHandle
@onready var handle_highlight : MeshInstance3D = $HandleOrigin/HandleHighlight

var controlling_hand = null

func _ready():
	handle_highlight.visible = false
	handle.grabbed.connect(self._on_interactable_handle_grabbed)
	handle.dropped.connect(self._on_interactable_handle_dropped)
	handle.highlight_updated.connect(self._on_interactable_handle_highlight_updated)
	_on_interactable_handle_dropped()

func _on_interactable_handle_grabbed(_pickable = null, _by = null):
	set_physics_process(true)
	controlling_hand = _by.get_parent()

func _on_interactable_handle_dropped(_pickable = null):
	set_physics_process(false)
	set_rotation(Vector3(-0.8, 0.0, 0.0))
	controlling_hand = null

func _on_interactable_handle_highlight_updated(pickable, enable):
	handle_highlight.visible = enable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var p = get_parent().to_local(handle.get_global_position())
	rotation.x = clamp(Vector2(Vector2(p.x, p.y).length(), p.z).angle(), -1.0, -0.4)
	rotation.z = clamp(Vector2(p.y, -p.x).angle(), -0.5, 0.5)
