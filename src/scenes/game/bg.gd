tool
extends Sprite

export var original_down_delta = 4

var down_delta = original_down_delta

func _ready():
	down_delta = original_down_delta
	if(!Engine.editor_hint):
		set_process(true)
	else:
		set_process(false)
	on_window_resize()
	get_node("/root/").connect("size_changed", self, "on_window_resize")
	
func _process(delta):
	set_region_rect(Rect2(Vector2(0,region_rect.position.y-down_delta),OS.get_window_size()))

func on_window_resize():
	if(Engine.editor_hint):
		set_region_rect(Rect2(Vector2(), Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))))
	else:
		set_region_rect(Rect2(Vector2(), OS.get_window_size()))

func stop_scrolling():
	set_process(false)

func start_scrolling():
	set_process(true)