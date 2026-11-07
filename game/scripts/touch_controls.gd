extends Control

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    _create_button("LEFT", "touch_left", Vector2(36, -150), Vector2(88, 88))
    _create_button("RIGHT", "touch_right", Vector2(132, -150), Vector2(88, 88))
    _create_button("BRAKE", "touch_brake", Vector2(-230, -150), Vector2(88, 88))
    _create_button("GO", "touch_accelerate", Vector2(-132, -150), Vector2(112, 112))

func _create_button(label: String, action: String, offset: Vector2, size: Vector2) -> void:
    var button := Button.new()
    button.text = label
    button.custom_minimum_size = size
    button.anchor_left = 0.0 if offset.x >= 0 else 1.0
    button.anchor_right = 0.0 if offset.x >= 0 else 1.0
    button.anchor_top = 1.0
    button.anchor_bottom = 1.0
    button.position = offset
    button.add_theme_font_size_override("font_size", 18)
    button.modulate = Color(1, 1, 1, 0.86)
    add_child(button)
    button.button_down.connect(func(): Input.action_press(action))
    button.button_up.connect(func(): Input.action_release(action))

func _exit_tree() -> void:
    for action in ["touch_left", "touch_right", "touch_brake", "touch_accelerate"]:
        Input.action_release(action)
