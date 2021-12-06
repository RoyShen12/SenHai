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

TUNING.SenHai = {}

TUNING.SenHai.storm_chance = GetModConfigData("StormChance")
TUNING.SenHai.storm_range = GetModConfigData("StormRange")
TUNING.SenHai.storm_damage_ratio = GetModConfigData("StormDamageRatio")
TUNING.SenHai.range = GetModConfigData("Range")
TUNING.SenHai.damage = GetModConfigData("Damage")

STRINGS.NAMES.SENHAI = "猪刀森海" --名字
STRINGS.RECIPE_DESC.SENHAI = "铸造一把猪刀" --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SENHAI = "粗~粗~粗~" --人物检查的描述

Recipe(
    "senhai",
    {
      Ingredient("twigs", 10)
    },
    RECIPETABS.WAR,
    TECH.NONE
  ).atlas = "images/inventoryimages/senhai.xml"

-- AddPrefabPostInit(
--   "krampus_sack",
--   function(inst)
--     if TheWorld.ismastersim then
--       if not inst:HasTag("fridge") then
--         inst:AddTag("fridge")
--       end

--       if inst.components.equippable ~= nil then
--         inst.components.equippable.walkspeedmult = 1.05
--       end
--     end
--   end
-- )

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
  spear = 1,
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
  hambat = 2,
  petals = 2,
  marble = 2,
  charcoal = 2,
  meat = 2,
  pigskin = 2,
  batwing = 2,
  spidergland = 2,
  mosquitosack = 2,
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
  ice = 3,
  gunpowder = 3,
  goldnugget = 3,
  beefalowool = 3,
  whip = 4,
  nightmarefuel = 4,
  petals_evil = 4,
  livinglog = 5,
  phlegm = 5,
  steelwool = 5,
  trunk_summer = 5,
  trunk_winter = 5,
  walrus_tusk = 5,
  feather_canary = 5,
  tentaclespots = 5,
  horn = 5,
  lightninggoathorn = 5,
  cookiecuttershell = 5,
  slurper_pelt = 5,
  fig = 5,
  boomerang = 5,
  redgem = 6,
  bluegem = 6,
  purplegem = 7,
  greengem = 7,
  orangegem = 8,
  yellowgem = 8,
  tentaclespike = 8,
  opalpreciousgem = 9,
  amulet = 10,
  blowdart_pipe = 10,
  blowdart_sleep = 10,
  blowdart_fire = 10,
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
  moonrocknugget = 40,
  moonglass = 100,
  thulecite = 100,
  moonglass_charged = 140,
  moonstorm_spark = 150,
  moonstorm_glass = 160,
  goose_feather = 200,
  ruins_bat = 200,
  ruinshat = 200,
  armorruins = 200,
  bearger_fur = 500,
  deerclops_eyeball = 1000,
  eyeturret_item = 1800,
  dragon_scales = 2500,
  shroom_skin = 3500,
  minotaurhorn = 10000,
  malbatross_beak = 30000,
  malbatross_feather = 30000,
  fossil_piece = 50000,
  fossil_piece_clean = 50000,
  alterguardianhat = 150000
}

setmetatable(
  GLOBAL.WeaponExpTable,
  {
    __index = function(t, k)
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
