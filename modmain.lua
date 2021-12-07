GLOBAL.setmetatable(
  env,
  {
    __index = function(t, k)
      return GLOBAL.rawget(GLOBAL, k)
    end
  }
)

PrefabFiles = {
  "senhai"
}

-- 天气棒
TUNING.TORNADOSTAFF_USES = 120
-- 懒人魔杖
TUNING.ORANGESTAFF_USES = 120
-- 唤星杖
TUNING.YELLOWSTAFF_USES = 120
-- 老奶奶
TUNING.WICKERBOTTOM_SANITY = 1000

TUNING.ARMORMARBLE = 150 * 7 * 0.7 * 15
TUNING.ARMORMARBLE_SLOW = 1.05

TUNING.ARMOR_RUINSHAT = 150 * 8 * 0.7 * 15

TUNING.ARMORRUINS = 150 * 12 * 0.7 * 15

TUNING.STARFISH_TRAP_DAMAGE = 420
-- TUNING.STARFISH_TRAP_RADIUS = 1.4
-- TUNING.STARFISH_TRAP_TIMING = {
--   BASE = 0.1,
--   VARIANCE = 0
-- }
TUNING.STARFISH_TRAP_NOTDAY_RESET = {
  BASE = 2 * 30 / 20,
  VARIANCE = 2
}

STRINGS.NAMES.SENHAI = "猪刀森海" --名字
STRINGS.RECIPE_DESC.SENHAI = "铸造一把猪猪刀" --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SENHAI = "粗~粗~粗~" --人物检查的描述

Recipe(
    "senhai",
    {
      Ingredient("torch", 1),
      Ingredient("spear", 1),
      Ingredient("pigskin", 1)
    },
    RECIPETABS.WAR,
    TECH.NONE
  ).atlas = "images/inventoryimages/senhai.xml"

local containers = require("containers")

local params = {}

local widget = {
  slotpos = {},
  -- animbank = "ui_krampusbag_2x12",
  -- animbuild = "ui_krampusbag_2x12",
  pos = Vector3(-5, -120, 0)
}

local height_base = 240
local pos_base = -162
local unit_size = 75

for y = -2, 7 do
  table.insert(widget.slotpos, Vector3(pos_base - unit_size, -unit_size * y + height_base, 0))
  table.insert(widget.slotpos, Vector3(pos_base + 0, -unit_size * y + height_base, 0))
  table.insert(widget.slotpos, Vector3(pos_base + unit_size, -unit_size * y + height_base, 0))
end

params.krampus_sack = {
  widget = widget,
  issidewidget = true,
  type = "pack",
  openlimit = 1
}

-- remax
for _, v in pairs(params) do
  containers.MAXITEMSLOTS =
    math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local containers_widgetsetup_base = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
  local t = params[prefab or container.inst.prefab]
  if t ~= nil then
    for k, v in pairs(t) do
      container[k] = v
    end
    container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
  else
    containers_widgetsetup_base(container, prefab, data)
  end
end

GLOBAL.WeaponExpTable = {
  wetgoop = 1,
  spoiled_food = 1,
  spear = 1,
  torch = 1,
  heatrock = 1,
  bedroll_straw = 1,
  spear_wathgrithr = 1,
  wathgrithrhat = 1,
  sewing_tape = 1,
  saltrock = 1,
  driftwood_log = 1,
  spoiled_fish = 1,
  spoiled_fish_small = 1,
  rottenegg = 1,
  ash = 1,
  feather_crow = 1,
  feather_robin = 1,
  feather_robin_winter = 1,
  silk = 1,
  cutgrass = 1,
  flint = 1,
  rocks = 1,
  nitre = 1,
  log = 1,
  twigs = 1,
  monstermeat = 1,
  poop = 1,
  guano = 1,
  boneshard = 1,
  houndstooth = 1,
  beardhair = 1,
  fishmeat_small = 1,
  smallmeat = 1,
  cutlichen = 1,
  cave_banana = 1,
  acorn = 1,
  pinecone = 1,
  twiggy_nut = 1,
  butterflywings = 1,
  hambat = 2,
  petals = 2,
  marble = 2,
  charcoal = 2,
  meat = 2,
  drumstick = 2,
  froglegs = 2,
  bird_egg = 2,
  fishmeat = 2,
  pigskin = 2,
  manrabbit_tail = 2,
  batwing = 2,
  spidergland = 2,
  mosquitosack = 2,
  sketch = 3,
  tacklesketch = 3,
  blueprint = 3,
  nightstick = 3,
  lightbulb = 3,
  wormlight = 3,
  wormlight_lesser = 3,
  honeycomb = 3,
  stinger = 3,
  cutreeds = 3,
  coontail = 3,
  gears = 3,
  thulecite_pieces = 3,
  glommerwings = 3,
  glommerfuel = 3,
  glommerflower = 3,
  ice = 3,
  tallbirdegg = 3,
  plantmeat = 3,
  gunpowder = 3,
  goldnugget = 3,
  beefalowool = 3,
  seeds = 3,
  whip = 4,
  nightmarefuel = 4,
  petals_evil = 4,
  livinglog = 5,
  phlegm = 5,
  spidereggsack = 5,
  steelwool = 5,
  trunk_summer = 5,
  trunk_winter = 5,
  trunk_cooked = 5,
  walrus_tusk = 5,
  feather_canary = 5,
  tentaclespots = 5,
  horn = 5,
  lightninggoathorn = 5,
  cookiecuttershell = 5,
  slurper_pelt = 5,
  cane = 5,
  fig = 5,
  boomerang = 5,
  slurtleslime = 6,
  redgem = 6,
  bluegem = 6,
  purplegem = 7,
  greengem = 7,
  orangegem = 8,
  yellowgem = 8,
  tentaclespike = 8,
  corn_seeds = 10,
  carrot_seeds = 10,
  eggplant_seeds = 10,
  pumpkin_seeds = 10,
  pomegranate_seeds = 10,
  durian_seeds = 10,
  dragonfruit_seeds = 10,
  watermelon_seeds = 10,
  amulet = 10,
  blowdart_pipe = 10,
  blowdart_sleep = 10,
  blowdart_fire = 10,
  dug_grass = 10,
  dug_sapling = 10,
  dug_berrybush = 10,
  dug_berrybush2 = 10,
  dug_berrybush_juicy = 10,
  dug_marsh_bush = 10,
  dug_rock_avocado_bush = 10,
  orangeamulet = 12,
  yellowamulet = 12,
  greenamulet = 12,
  blueamulet = 12,
  purpleamulet = 12,
  blowdart_yellow = 15,
  icestaff = 15,
  firestaff = 15,
  telestaff = 20,
  orangestaff = 20,
  staff_tornado = 20,
  greenstaff = 20,
  yellowstaff = 25,
  opalstaff = 30,
  fossil_piece = 35,
  fossil_piece_clean = 35,
  moonrocknugget = 40,
  moonglass = 100,
  thulecite = 100,
  moonglass_charged = 140,
  moonstorm_spark = 150,
  moonstorm_glass = 160,
  spiderhat = 180,
  hivehat = 180,
  royal_jelly = 200,
  goose_feather = 200,
  ruins_bat = 200,
  ruinshat = 200,
  armorruins = 200,
  bearger_fur = 500,
  mandrake = 500,
  cookedmandrake = 510,
  mandrakesoup = 550,
  butter = 600,
  deerclops_eyeball = 1000,
  eyeturret_item = 1800,
  expbean = 2000,
  dragon_scales = 2500,
  shroom_skin = 3500,
  malbatross_beak = 5000,
  malbatross_feather = 5000,
  minotaurhorn = 10000,
  opalpreciousgem = 30000,
  alterguardianhat = 150000
}

for num = 1, NUM_TRINKETS do
  GLOBAL.WeaponExpTable["trinket_" .. tostring(num)] = function()
    return math.random(10, 100)
  end
end

setmetatable(
  GLOBAL.WeaponExpTable,
  {
    __index = function(t, k)
      -- if string.find(k, "seeds") then
      --   return 2
      -- end
      -- if string.match(k, ".*hat$") then
      --   return 10
      -- end
      -- if string.match(k, "^armor.*") then
      --   return 10
      -- end

      return 0.1
    end
  }
)

for prefab, _ in pairs(GLOBAL.WeaponExpTable) do
  AddPrefabPostInit(
    prefab,
    function(inst)
      if not inst.components.tradable then
        inst:AddComponent("tradable")
      end
    end
  )
end

AddPrefabPostInit(
  "armorruins",
  function(inst)
    inst.components.equippable.walkspeedmult = 1.05
  end
)

AddPrefabPostInit(
  "ruinshat",
  function(inst)
    inst.components.equippable.walkspeedmult = 1.05
  end
)

-- GLOBAL.WeaponExpTable.senhai = 10

GLOBAL.c_link = function(w1, w2)
  if
    w1 and w2 and type(w1) == "table" and type(w2) == "table" and w1.prefab == "wormhole" and
      w2.prefab == "wormhole" and
      w1.components.teleporter and
      w2.components.teleporter and
      w1.components.teleporter.targetTeleporter == nil and
      w2.components.teleporter.targetTeleporter == nil
   then
    w1.components.teleporter.targetTeleporter = w2
    w2.components.teleporter.targetTeleporter = w1
  end
end
