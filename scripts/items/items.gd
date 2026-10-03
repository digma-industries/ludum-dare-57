extends Node

var GEAR_REGISTRY = [
  ## Drill
  Item.new(
    "Titanium Drill",
    "Stronger than the standard issue.",
    "Dig 50% faster.",
    Item.Category.DRILL, 100.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new(
    "Overdrive Rotor",
    "Any professional would consider you just a hobbyist miner unless you've got one of these bad boys installed.",
    "Dig 100% faster than the base drill.",
    Item.Category.DRILL, 1000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 0.5}),
  Item.new(
    "Worldbreaker Bit",
    "You'll be digging through the earth like it was made out of rice crispies.",
    "Dig 200% faster than the base drill.",
    Item.Category.DRILL, 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_POWER: 1.0}),
  ## Heat
  Item.new(
    "Wood Heat Sink",
    "\"It ain't much and it doesn't work\"",
    "Drill can get up to 150C before overheating.",
    Item.Category.HEAT, 50.0, Item.Type.GEAR, {Item.StatImpact.HEAT_CAPACITY: 50.0}),
  Item.new(
    "Aluminum Heat Sink",
    "Lightweight. Reliable. Not recommended as a cooking surface.",
    "Drill can get up to 250C before overheating, and the drill cools off faster.",
    Item.Category.HEAT, 500.0, Item.Type.GEAR, {Item.StatImpact.HEAT_CAPACITY: 100.0, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  Item.new(
    "CryoCooler™",
    "Uses proprietary technology to keep the drill cool for extended mining sessions.",
    "Slows the speed at which the drill heats up, and the drill cools off even faster.",
    Item.Category.HEAT, 5000.0, Item.Type.GEAR, {Item.StatImpact.DIGGING_HEAT_GEN: -0.2, Item.StatImpact.HEAT_DECAY_RATE: 0.5}),
  ## Fuel
  Item.new(
    "Auxiliary Fuel Tank",
    "This could come in handy.",
    "Carry an extra 1L of fuel.",
    Item.Category.FUEL, 200.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Ancillary Fuel Tank",
    "Now you can delve even deeper before you realize you can't make it back to the surface.",
    "Carry an extra 1000mL of fuel.",
    Item.Category.FUEL, 500.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Supplementary Fuel Tank",
    "Just in case we want to go on an extended spelunking adventure.",
    "Carry an extra 1kg of dense-as-water fuel.",
    Item.Category.FUEL, 2000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Backup Fuel Tank",
    "I'm starting to think this shopkeeper is price gouging me.",
    "Carry an extra 0.264gal of fuel.",
    Item.Category.FUEL, 10000.0, Item.Type.GEAR, {Item.StatImpact.FUEL_CAPACITY: 1000}),
  Item.new(
    "Exhaust Flow Reclaimer",
    "Useful for trips to the moon.",
    "Jetpack uses half as much fuel.",
    Item.Category.FUEL, 10000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_FUEL_EFFICIENCY: -2.5}),
  ## Jetpack
  Item.new(
    "Jetpack Turbo Booster",
    "The ceiling will come at you so fast you'd think it was the ground.",
    "Increases top speed of the jetpack.",
    Item.Category.JETPACK, 5000.0, Item.Type.GEAR, {Item.StatImpact.JETPACK_SPEED_LIMIT: 75.0}),
  ## Weight
  Item.new(
    "3025 NBA All Stars Nike Sneakers",
    "Authenticity not verified.",
    "Reduces weight by 50kg.",
    Item.Category.WEIGHT, 5000.0, Item.Type.GEAR, {Item.StatImpact.PLAYER_WEIGHT: -50.0}),
]
