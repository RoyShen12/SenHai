GLOBAL.setmetatable(
  env,
  {
    __index = function(t, k)
      return GLOBAL.rawget(GLOBAL, k)
    end
  }
)

PrefabFiles = {
  "senhai",
  "moonspider_spike_senhai",
  "senhai_projectile"
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

GLOBAL.WeaponExpTable = require("senhai-constants").WeaponExpTable

AddPrefabPostInit(
  "armorruins",
  function(inst)
    if TheWorld.ismastersim then
      inst.components.equippable.walkspeedmult = 1.05
    end
  end
)

AddPrefabPostInit(
  "ruinshat",
  function(inst)
    if TheWorld.ismastersim then
      inst.components.equippable.walkspeedmult = 1.05
    end
  end
)

AddPrefabPostInit(
  "chester",
  function(inst)
    if TheWorld.ismastersim then
      if not inst:HasTag("spider") then
        inst:AddTag("spiderdisguise")
      end
      if not inst:HasTag("hound") then
        inst:AddTag("houndfriend")
      end
    end
  end
)

AddPrefabPostInit(
  "hutch",
  function(inst)
    if TheWorld.ismastersim then
      if not inst:HasTag("spider") then
        inst:AddTag("spiderdisguise")
      end
      if not inst:HasTag("hound") then
        inst:AddTag("houndfriend")
      end
    end
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

AddModRPCHandler(
  "senhai",
  "SwitchSummon",
  function(player, senhai_inst)
    -- print("recieve ModRPC senhai", ...)
    if
        senhai_inst:IsValid() and player:IsValid() and player.components.health and
        not player.components.health:IsDead() and
        not player:HasTag("playerghost") and
        senhai_inst.components.inventoryitem:GetGrandOwner() == player and
        senhai_inst.components.equippable:IsEquipped() and
        senhai_inst.summon_amount > 0
    then
      if senhai_inst.SummonEnabled then
        player.components.talker:Say("禁用召唤功能")
        senhai_inst.SummonEnabled = false

        for _, summon in ipairs(senhai_inst.Summons) do
          senhai_inst:DoTaskInTime(
            math.random() * 0.3,
            function()
              summon:Remove()
            end
          )
        end
        senhai_inst.Summons = {}
      else
        player.components.talker:Say("恢复召唤功能")
        senhai_inst.SummonEnabled = true
      end
    end
  end
)

AddModRPCHandler(
  "senhai",
  "SwitchHammerAndShovel",
  function(player, senhai_inst)
    if
        senhai_inst:IsValid() and player:IsValid() and player.components.health and
        not player.components.health:IsDead() and
        not player:HasTag("playerghost") and
        senhai_inst.components.inventoryitem:GetGrandOwner() == player and
        senhai_inst.components.equippable:IsEquipped()
    then
      if
          senhai_inst.components.tool:CanDoAction(ACTIONS.HAMMER) or
          senhai_inst.components.tool:CanDoAction(ACTIONS.DIG)
      then
        player.components.talker:Say("禁用铲子和锤子")
        senhai_inst.components.tool.actions[ACTIONS.HAMMER] = nil
        senhai_inst.components.tool.actions[ACTIONS.DIG] = nil
        senhai_inst:RemoveTag(ACTIONS.HAMMER.id .. "_tool")
        senhai_inst:RemoveTag(ACTIONS.DIG.id .. "_tool")
      else
        player.components.talker:Say("启用铲子和锤子")
        senhai_inst.components.tool:SetAction(ACTIONS.HAMMER, senhai_inst.hammer_power)
        senhai_inst.components.tool:SetAction(ACTIONS.DIG, senhai_inst.dig_power)
      end
    end
  end
)

AddModRPCHandler(
  "senhai",
  "TpToFriend",
  function(player, senhai_inst)
    if
        not TheNet:GetPVPEnabled() and #AllPlayers > 1 and senhai_inst:IsValid() and player:IsValid() and
        player.components.health and
        not player.components.health:IsDead() and
        not player:HasTag("playerghost") and
        senhai_inst.components.inventoryitem:GetGrandOwner() == player and
        senhai_inst.components.equippable:IsEquipped()
    then
      local senhai_equipped_players = {}

      for _, other_player in ipairs(AllPlayers) do
        local in_hand =
            other_player.components.inventory and
            other_player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or
            nil
        if
            other_player:IsValid() and other_player.Transform and other_player.components.health and
            not other_player.components.health:IsDead() and
            not other_player:HasTag("playerghost") and
            in_hand and
            in_hand:IsValid() and
            in_hand.prefab == "senhai"
        then
          table.insert(senhai_equipped_players, other_player)
        end
      end

      if
          #senhai_equipped_players > 0 and player.components.hunger.current > 30 and
          player.components.sanity.current > 30
      then
        local target_player = senhai_equipped_players[math.random(#senhai_equipped_players)]

        player.components.talker:Say("传送到另一个森海持有者！")

        player.components.sanity:DoDelta(-30)
        player.components.hunger:DoDelta(-30)

        player.Transform:SetPosition(target_player.Transform:GetWorldPosition())
      end
    end
  end
)
