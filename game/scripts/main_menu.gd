extends Control

func _ready() -> void:
    _build_ui()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#1d3557")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    var decor := ColorRect.new()
    decor.color = Color("#457b9d")
    decor.position = Vector2(0, 420)
    decor.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
    decor.custom_minimum_size.y = 300
    add_child(decor)
    var title := Label.new()
    title.text = "SMASHCARTS"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 64)
    title.add_theme_color_override("font_color", Color("#f1faee"))
    title.anchor_left = 0.1
    title.anchor_right = 0.9
    title.anchor_top = 0.18
    title.anchor_bottom = 0.35
    add_child(title)
    var subtitle := Label.new()
    subtitle.text = "KART BATTLE • PHASE 1 PROTOTYPE"
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle.add_theme_font_size_override("font_size", 20)
    subtitle.add_theme_color_override("font_color", Color("#a8dadc"))
    subtitle.anchor_left = 0.1
    subtitle.anchor_right = 0.9
    subtitle.anchor_top = 0.36
    subtitle.anchor_bottom = 0.44
    add_child(subtitle)
    var play := Button.new()
    play.text = "PLAY TEST ARENA"
    play.custom_minimum_size = Vector2(300, 76)
    play.add_theme_font_size_override("font_size", 26)
    play.anchor_left = 0.5
    play.anchor_top = 0.57
    play.anchor_right = 0.5
    play.anchor_bottom = 0.57
    play.position = Vector2(-150, 0)
    play.pressed.connect(_start_game)
    add_child(play)
    var note := Label.new()
    note.text = "Drive with WASD / arrow keys or touchscreen controls"
    note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    note.add_theme_font_size_override("font_size", 16)
    note.add_theme_color_override("font_color", Color("#f1faee"))
    note.anchor_left = 0.08
    note.anchor_right = 0.92
    note.anchor_top = 0.78
    note.anchor_bottom = 0.9
    add_child(note)

func _start_game() -> void:
    get_tree().change_scene_to_file("res://scenes/test_arena.tscn")
