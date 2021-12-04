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
