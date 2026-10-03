@tool
extends Node2D

## Draws randomly placed white stars across `area`. Meant to be the child of a
## Parallax2D whose repeat_size matches `area`, so the pattern tiles seamlessly.

@export var area := Vector2(480, 480):
  set(value):
    area = value
    queue_redraw()
@export var star_count := 60:
  set(value):
    star_count = value
    queue_redraw()
# chance for a star to be 2x2 instead of a single pixel
@export_range(0.0, 1.0) var big_star_chance := 0.0:
  set(value):
    big_star_chance = value
    queue_redraw()
@export_range(0.0, 1.0) var min_alpha := 0.3:
  set(value):
    min_alpha = value
    queue_redraw()
@export_range(0.0, 1.0) var max_alpha := 1.0:
  set(value):
    max_alpha = value
    queue_redraw()
# fixed seed so the sky looks the same every run (and in the editor)
@export var star_seed := 0:
  set(value):
    star_seed = value
    queue_redraw()

func _draw() -> void:
  var rng := RandomNumberGenerator.new()
  rng.seed = star_seed
  print("Drawing stars with seed %d" % star_seed)
  for i in star_count:
    # whole pixels keep the stars crisp with the pixel-art filtering
    var pos := Vector2(floorf(rng.randf() * area.x), floorf(rng.randf() * area.y))
    var size := 2.0 if rng.randf() < big_star_chance else 1.0
    var color := Color(1.0, 1.0, 1.0, rng.randf_range(min_alpha, max_alpha))
    draw_rect(Rect2(pos, Vector2(size, size)), color)
