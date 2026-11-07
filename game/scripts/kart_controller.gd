extends CharacterBody3D

@export var acceleration: float = 22.0
@export var reverse_acceleration: float = 12.0
@export var max_speed: float = 17.0
@export var reverse_max_speed: float = 7.0
@export var steering_strength: float = 2.25
@export var drag: float = 8.0
@export var handbrake_drag: float = 18.0

var forward_speed: float = 0.0
var steer_input: float = 0.0
var throttle_input: float = 0.0
var handbrake_input: bool = false
var visual_root: Node3D
var camera_pivot: Node3D

func _ready() -> void:
    _build_kart_visuals()
    _build_collision()
    _build_camera()

func _physics_process(delta: float) -> void:
    _read_controls()
    _simulate_kart(delta)
    _update_camera(delta)

func _read_controls() -> void:
    throttle_input = Input.get_action_strength("accelerate") - Input.get_action_strength("brake")
    steer_input = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
    handbrake_input = Input.is_action_pressed("handbrake")
    throttle_input = max(throttle_input, Input.get_action_strength("touch_accelerate"))
    throttle_input = min(throttle_input, 0.0) if Input.get_action_strength("touch_brake") > 0.5 else throttle_input
    steer_input += Input.get_action_strength("touch_right") - Input.get_action_strength("touch_left")

func _simulate_kart(delta: float) -> void:
    if throttle_input > 0.0:
        forward_speed = move_toward(forward_speed, max_speed * throttle_input, acceleration * delta)
    elif throttle_input < 0.0:
        if forward_speed > 0.5:
            forward_speed = move_toward(forward_speed, 0.0, reverse_acceleration * delta)
        else:
            forward_speed = move_toward(forward_speed, -reverse_max_speed, reverse_acceleration * delta)
    else:
        var current_drag := handbrake_drag if handbrake_input else drag
        forward_speed = move_toward(forward_speed, 0.0, current_drag * delta)

    var speed_factor := clamp(abs(forward_speed) / max_speed, 0.0, 1.0)
    if abs(forward_speed) > 0.25:
        var direction_sign := 1.0 if forward_speed >= 0.0 else -1.0
        rotation.y -= steer_input * steering_strength * speed_factor * direction_sign * delta

    var forward := -global_transform.basis.z
    velocity.x = forward.x * forward_speed
    velocity.z = forward.z * forward_speed
    velocity.y -= 24.0 * delta
    move_and_slide()
    if is_on_floor() and velocity.y < 0.0:
        velocity.y = -0.5

func _build_collision() -> void:
    var shape_node := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = Vector3(1.7, 0.8, 2.5)
    shape_node.shape = shape
    add_child(shape_node)

func _build_kart_visuals() -> void:
    visual_root = Node3D.new()
    visual_root.name = "KartVisuals"
    add_child(visual_root)
    _add_visual_box("Chassis", Vector3(0, 0.0, 0), Vector3(1.7, 0.45, 2.4), Color("#e63946"))
    _add_visual_box("Nose", Vector3(0, 0.18, -0.95), Vector3(1.25, 0.25, 0.65), Color("#f1faee"))
    _add_visual_box("Seat", Vector3(0, 0.42, 0.28), Vector3(0.9, 0.65, 0.9), Color("#264653"))
    _add_visual_box("DriverHead", Vector3(0, 0.92, 0.2), Vector3(0.58, 0.58, 0.58), Color("#f4c7a1"))
    for x in [-0.95, 0.95]:
        for z in [-0.78, 0.78]:
            var wheel := MeshInstance3D.new()
            var cylinder := CylinderMesh.new()
            cylinder.top_radius = 0.34
            cylinder.bottom_radius = 0.34
            cylinder.height = 0.22
            wheel.mesh = cylinder
            wheel.position = Vector3(x, -0.12, z)
            wheel.rotation.z = PI / 2.0
            var mat := StandardMaterial3D.new()
            mat.albedo_color = Color("#222222")
            wheel.material_override = mat
            visual_root.add_child(wheel)

func _add_visual_box(node_name: String, pos: Vector3, size: Vector3, color: Color) -> void:
    var mesh := MeshInstance3D.new()
    mesh.name = node_name
    var box := BoxMesh.new()
    box.size = size
    mesh.mesh = box
    mesh.position = pos
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 0.72
    mesh.material_override = mat
    visual_root.add_child(mesh)

func _build_camera() -> void:
    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0, 2.4, 0)
    add_child(camera_pivot)
    var camera := Camera3D.new()
    camera.position = Vector3(0, 4.0, 8.5)
    camera.rotation_degrees = Vector3(-18, 0, 0)
    camera.current = true
    camera.fov = 72
    camera_pivot.add_child(camera)

func _update_camera(delta: float) -> void:
    if camera_pivot:
        camera_pivot.global_position = camera_pivot.global_position.lerp(global_position + Vector3(0, 2.4, 0), 1.0 - exp(-5.0 * delta))
