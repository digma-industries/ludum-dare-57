extends CanvasLayer

signal close_requested

var item_button_scene = preload("res://scenes/shop_ui/item_button.tscn")

const STAT_ROW_TEMPLATE := "[cell padding=0,0,16,0]%s[/cell][cell][code]%s → [color=%s]%s[/color][/code][/cell]"
const BETTER_COLOR := "#99e550"
const WORSE_COLOR := "#d95763"
const PURCHASE_FLASH_COLOR := Color(1.5, 1.4, 1.1)

# item name -> button for buying item
var buttons: Dictionary[String, ItemButton]
# own copy of the quote style so its bar can match the item's category color
var flavor_quote_style: StyleBoxFlat

func _ready():
  flavor_quote_style = %FlavorQuote.get_theme_stylebox("panel").duplicate()
  %FlavorQuote.add_theme_stylebox_override("panel", flavor_quote_style)

  # Create a button for every item, but don't show them
  for item in Items.GEAR_REGISTRY:
    var instance: ItemButton = item_button_scene.instantiate()
    %GearContainer.add_child(instance)
    var category_items = Items.GEAR_REGISTRY.filter(func(other): return other.category == item.category)
    instance.setup(item, category_items.find(item) + 1, category_items.size())
    instance.visible = false
    instance.pressed.connect(item_button_pressed.bind(instance))
    instance.mouse_entered.connect(show_details.bind(item))
    instance.focus_entered.connect(show_details.bind(item))
    buttons[item.name] = instance

func _input(event: InputEvent):
  if !visible:
    return
  # space is jump, so don't let it also buy the focused item
  if event is InputEventKey && event.physical_keycode == KEY_SPACE:
    get_viewport().set_input_as_handled()
  elif event.is_action_pressed("ui_cancel"):
    get_viewport().set_input_as_handled()
    close_requested.emit()

func open(sold_amount: float):
  visible = true
  %SoldLabel.visible = sold_amount > 0
  %SoldLabel.text = "Sold haul: +$%d" % sold_amount
  update_button_states()
  focus_first_button()

func close():
  visible = false
  get_viewport().gui_release_focus()

func get_items_to_show():
  var items_to_show: Array[String] = []
  for category in Item.Category.values():
    # Find the first item in the registry with that category that the player has not purchased
    var item_idx = Items.GEAR_REGISTRY.find_custom(func(item):
      return item.category == category && !GameState.purchased_items.has(item.name)
    )
    if item_idx >= 0:
      items_to_show.append(Items.GEAR_REGISTRY[item_idx].name)
  return items_to_show

func update_button_states():
  # Only show the first item of each category that hasn't been purchased, and color prices by affordability
  var items_to_show = get_items_to_show()
  for itemName in buttons:
    buttons[itemName].visible = items_to_show.has(itemName)
    buttons[itemName].set_affordable(GameState.player.bank_value >= buttons[itemName].item.price)

  %Money.text = "$%d" % GameState.player.bank_value
  %AllItemsPurchased.visible = items_to_show.is_empty()
  %Details.visible = !items_to_show.is_empty()

func focus_first_button(category = null):
  # Prefer the next item in the given category, otherwise the first item shown
  var shown = %GearContainer.get_children().filter(func(button):
    return button.visible && !button.is_queued_for_deletion()
  )
  if shown.is_empty():
    return
  var matching = shown.filter(func(button): return button.item.category == category)
  var target = matching[0] if !matching.is_empty() else shown[0]
  target.grab_focus()
  show_details(target.item)

func item_button_pressed(button: ItemButton):
  if GameState.player.bank_value < button.item.price:
    button.shake()
    return

  GameState.purchased_items.append(button.item.name)
  GameState.player.bank_value -= button.item.price
  button.item.apply()
  button.queue_free()
  buttons.erase(button.item.name)
  update_button_states()
  focus_first_button(button.item.category)

  $PurchaseSound.play()
  %Panel.modulate = PURCHASE_FLASH_COLOR
  create_tween().tween_property(%Panel, "modulate", Color.WHITE, 0.3)

func show_details(item: Item):
  %ItemName.text = item.name
  %Flavor.text = "[i]%s[/i]" % item.flavor
  flavor_quote_style.border_color = ItemButton.CATEGORY_COLORS[item.category]
  %Description.text = item.description
  %Stats.text = get_stats_bbcode(item)

# table of each stat the item changes, as "current → new"
func get_stats_bbcode(item: Item) -> String:
  var rows = ""
  for stat in item.statImpact:
    var display = Item.STAT_DISPLAY[stat]
    var current = Item.current_stat(stat)
    var next = current + item.statImpact[stat]
    var lower_is_better = display[3]
    var color = BETTER_COLOR if (next < current) == lower_is_better else WORSE_COLOR
    rows += STAT_ROW_TEMPLATE % [display[0], display[1] % (current * display[2]), color, display[1] % (next * display[2])]
  return "[table=2]%s[/table]" % rows
