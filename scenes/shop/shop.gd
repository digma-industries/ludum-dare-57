extends Node2D

# true if the player is at the shop
var player_present = false
# true if the player is shopping (i.e. they pressed interact while at the shop)
var is_shopping = false

func _ready():
  $ShopUI.close_requested.connect(close_shop)

func _process(delta):
  if Input.is_action_just_pressed("interact") && player_present && !is_shopping:
    open_shop()

func open_shop():
  is_shopping = true
  GameState.player.is_shopping = true
  var sold_amount = GameState.player.haul_value
  GameState.player.sell_haul()
  $ShopUI.open(sold_amount)
  $FGlyph.visible = false

func close_shop():
  is_shopping = false
  GameState.player.is_shopping = false
  $ShopUI.close()
  # still standing at the shop, so show the prompt to reopen it
  $FGlyph.visible = player_present
  if player_present:
    $FGlyph.play()

func _on_player_entered(body: Node2D) -> void:
  player_present = true
  $FGlyph.visible = true
  $FGlyph.play()

func _on_player_exited(body: Node2D) -> void:
  player_present = false
  close_shop()
