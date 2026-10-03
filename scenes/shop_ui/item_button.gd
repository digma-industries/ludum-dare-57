class_name ItemButton extends Button

const CATEGORY_COLORS: Dictionary[Item.Category, Color] = {
  Item.Category.DRILL: Color("#d9a066"),
  Item.Category.JETPACK: Color("#99e550"),
  Item.Category.FUEL: Color("#ffa600"),
  Item.Category.HEAT: Color("#639bff"),
  Item.Category.WEIGHT: Color("#d77bba"),
}
const AFFORDABLE_COLOR := Color("#99e550")
const UNAFFORDABLE_COLOR := Color("#d95763")
const PIP_SIZE := Vector2(10, 10)
const PIP_EMPTY_COLOR := Color(0.3, 0.3, 0.3)

var item: Item

# tier is 1-indexed position of this item within its category
func setup(item: Item, tier: int, tier_count: int) -> void:
  self.item = item
  var category_color = CATEGORY_COLORS[item.category]
  $Row/Info/Category.text = Item.Category.keys()[item.category]
  $Row/Info/Category.add_theme_color_override("font_color", category_color)
  $Row/Info/Name.text = item.name
  $Row/Price.text = "$%d" % item.price
  # one pip per item in the category, filled up to this item's tier
  for i in tier_count:
    var pip = ColorRect.new()
    pip.custom_minimum_size = PIP_SIZE
    pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
    pip.color = category_color if i < tier else PIP_EMPTY_COLOR
    $Row/Tier.add_child(pip)

func set_affordable(affordable: bool) -> void:
  $Row/Price.add_theme_color_override("font_color", AFFORDABLE_COLOR if affordable else UNAFFORDABLE_COLOR)
  $Row/Info/Name.modulate.a = 1.0 if affordable else 0.6

# wiggle the row to show the item can't be bought
func shake() -> void:
  var tween = create_tween()
  for offset in [-8.0, 8.0, -5.0, 5.0, 0.0]:
    tween.tween_property($Row, "position:x", 16.0 + offset, 0.04)
