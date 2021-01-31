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

TUNING.SenHai = {}

TUNING.SenHai.storm_chance = GetModConfigData("StormChance")
TUNING.SenHai.storm_range = GetModConfigData("StormRange")
TUNING.SenHai.storm_damage_ratio = GetModConfigData("StormDamageRatio")
TUNING.SenHai.range = GetModConfigData("Range")

STRINGS.NAMES.SENHAI = "猪刀森海" --名字
STRINGS.RECIPE_DESC.SENHAI = "铸造一把猪刀" --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SENHAI = "粗~粗~粗~" --人物检查的描述

Recipe(
  "senhai",
  {
    Ingredient("goldenaxe", 1),
    Ingredient("cane", 1),
    Ingredient("redgem", 2),
  },
  RECIPETABS.WAR,
  {SCIENCE = 0}
).atlas = "images/inventoryimages/senhai.xml"
