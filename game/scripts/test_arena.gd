extends Node3D

func _ready() -> void:
    _create_world()
    _create_kart()
    _create_hud()

func _create_world() -> void:
    var environment := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    env.sky = Sky.new()
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color("#b7d9f2")
    env.ambient_light_energy = 0.8
    environment.environment = env
    add_child(environment)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -32, 0)
    sun.light_energy = 1.2
    add_child(sun)
    _add_box("ArenaFloor", Vector3(0, -0.5, 0), Vector3(42, 1, 42), Color("#69a85a"))
    for x in [-20.0, 20.0]:
        _add_box("SideWall", Vector3(x, 0.6, 0), Vector3(1, 1.2, 40), Color("#e9c46a"))
    for z in [-20.0, 20.0]:
        _add_box("EndWall", Vector3(0, 0.6, z), Vector3(40, 1.2, 1), Color("#e9c46a"))
    for p in [Vector3(-8, 0.8, -6), Vector3(8, 0.8, -7), Vector3(-7, 0.8, 8), Vector3(9, 0.8, 7)]:
        _add_box("Obstacle", p, Vector3(2.2, 1.6, 2.2), Color("#e76f51"))
    for p in [Vector3(-13, 0.7, 0), Vector3(13, 0.7, 0), Vector3(0, 0.7, -13), Vector3(0, 0.7, 13)]:
        _add_box("Barrier", p, Vector3(3, 1.4, 1.2), Color("#f4a261"))
    for p in [Vector3(-17, 0, -16), Vector3(16, 0, -16), Vector3(-17, 0, 16), Vector3(16, 0, 16)]:
        var trunk := _make_mesh_body("TreeTrunk", p + Vector3(0, 1, 0), CylinderMesh.new(), Color("#805b3b"))
        trunk.scale = Vector3(0.35, 1.0, 0.35)
        var crown := _make_mesh_body("TreeCrown", p + Vector3(0, 2.5, 0), SphereMesh.new(), Color("#2a9d8f"))
        crown.scale = Vector3(1.3, 1.5, 1.3)

func _add_box(node_name: String, pos: Vector3, size: Vector3, color: Color) -> void:
    var body := StaticBody3D.new()
    body.name = node_name
    body.position = pos
    var mesh := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = size
    mesh.mesh = box
    mesh.material_override = _material(color)
    body.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    body.add_child(collision)
    add_child(body)

func _make_mesh_body(node_name: String, pos: Vector3, mesh_resource: PrimitiveMesh, color: Color) -> MeshInstance3D:
    var mesh := MeshInstance3D.new()
    mesh.name = node_name
    mesh.position = pos
    mesh.mesh = mesh_resource
    mesh.material_override = _material(color)
    add_child(mesh)
    return mesh

func _material(color: Color) -> StandardMaterial3D:
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 0.82
    return mat

func _create_kart() -> void:
    var kart := CharacterBody3D.new()
    kart.name = "PlayerKart"
    kart.position = Vector3(0, 0.8, 0)
    kart.set_script(load("res://scripts/kart_controller.gd"))
    add_child(kart)

func _create_hud() -> void:
    var hud := CanvasLayer.new()
    hud.name = "HUD"
    add_child(hud)
    var label := Label.new()
    label.name = "Status"
    label.text = "TEST ARENA  •  SOLO PROTOTYPE"
    label.position = Vector2(24, 18)
    label.add_theme_font_size_override("font_size", 20)
    label.add_theme_color_override("font_color", Color.WHITE)
    hud.add_child(label)
    var back := Button.new()
    back.text = "MENU"
    back.position = Vector2(24, 58)
    back.custom_minimum_size = Vector2(110, 48)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
    hud.add_child(back)
    var controls := Control.new()
    controls.set_script(load("res://scripts/touch_controls.gd"))
    controls.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    hud.add_child(controls)
