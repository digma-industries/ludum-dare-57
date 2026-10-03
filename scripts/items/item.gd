class_name Item extends Object

enum Type {GEAR, CONSUMABLE}
enum StatImpact {
  PLAYER_WEIGHT,
  FUEL_CAPACITY,
  MAX_JETPACK_ACCEL,
  MIN_JETPACK_ACCEL,
  JETPACK_ACCEL_PENALTY,
  JETPACK_SPEED_LIMIT,
  JETPACK_FUEL_EFFICIENCY,
  CURRENT_FUEL,
  DIGGING_POWER,
  DIGGING_HEAT_GEN,
  HEAT_CAPACITY,
  HEAT_DECAY_RATE,
}
enum Category {DRILL, JETPACK, FUEL, HEAT, WEIGHT}

# player property modified by each stat
const STAT_PROPERTIES: Dictionary[StatImpact, String] = {
  StatImpact.PLAYER_WEIGHT: "player_weight",
  StatImpact.FUEL_CAPACITY: "fuel_capacity",
  StatImpact.MAX_JETPACK_ACCEL: "max_jetpack_accel",
  StatImpact.MIN_JETPACK_ACCEL: "min_jetpack_accel",
  StatImpact.JETPACK_ACCEL_PENALTY: "jetpack_accel_penalty",
  StatImpact.JETPACK_SPEED_LIMIT: "max_jetpack_top_speed",
  StatImpact.JETPACK_FUEL_EFFICIENCY: "jetpack_fuel_efficiency",
  StatImpact.CURRENT_FUEL: "current_fuel",
  StatImpact.DIGGING_POWER: "digging_power",
  StatImpact.DIGGING_HEAT_GEN: "digging_heat_gen",
  StatImpact.HEAT_CAPACITY: "heat_capacity",
  StatImpact.HEAT_DECAY_RATE: "heat_decay_rate",
}

# how each stat is shown in the shop: [label, format, display scale, lower is better]
# per-frame stats are scaled by 60 to show them per second
const STAT_DISPLAY: Dictionary[StatImpact, Array] = {
  StatImpact.PLAYER_WEIGHT: ["Body weight", "%dkg", 1.0, true],
  StatImpact.FUEL_CAPACITY: ["Fuel tank", "%.1fL", 0.001, false],
  StatImpact.MAX_JETPACK_ACCEL: ["Jetpack thrust", "%d", 1.0, false],
  StatImpact.MIN_JETPACK_ACCEL: ["Min jetpack thrust", "%d", 1.0, false],
  StatImpact.JETPACK_ACCEL_PENALTY: ["Thrust lost per kg", "%.2f", 1.0, true],
  StatImpact.JETPACK_SPEED_LIMIT: ["Jetpack speed", "%d", 1.0, false],
  StatImpact.JETPACK_FUEL_EFFICIENCY: ["Fuel use", "%dmL/s", 60.0, true],
  StatImpact.CURRENT_FUEL: ["Fuel", "%.1fL", 0.001, false],
  StatImpact.DIGGING_POWER: ["Dig speed", "%.1fx", 1.0, false],
  StatImpact.DIGGING_HEAT_GEN: ["Drill heating", "%dC/s", 60.0, true],
  StatImpact.HEAT_CAPACITY: ["Max drill heat", "%dC", 1.0, false],
  StatImpact.HEAT_DECAY_RATE: ["Drill cooling", "%dC/s", 60.0, false],
}

var type: Type
var statImpact: Dictionary[StatImpact, float]
var name: String
# joke text shown as a quote in the shop
var flavor: String
# what the item does, in plain terms
var description: String
var price: float
var category: Category

func _init(name: String, flavor: String, description: String, category: Category, price: float, type: Type, statImpact: Dictionary[StatImpact, float]) -> void:
  self.type = type
  self.statImpact = statImpact
  self.name = name
  self.flavor = flavor
  self.description = description
  self.price = price
  self.category = category

func apply() -> void:
  for key in statImpact:
    var property = STAT_PROPERTIES[key]
    GameState.player.set(property, GameState.player.get(property) + statImpact[key])
    if key == StatImpact.FUEL_CAPACITY:
      GameState.player.refuel()

# the player's current value for a stat
static func current_stat(stat: StatImpact) -> float:
  return GameState.player.get(STAT_PROPERTIES[stat])
