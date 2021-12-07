local assets = {
  Asset("ANIM", "anim/senhai.zip"), --地上的动画
  Asset("ANIM", "anim/swap_senhai.zip"),
  Asset("ATLAS", "images/inventoryimages/senhai.xml") --加载物品栏贴图
}

local function CreateLight()
  local inst = CreateEntity()

  inst:AddTag("FX")
  inst:AddTag("playerlight")
  --[[Non-networked entity]]
  inst.entity:SetCanSleep(false)
  inst.persists = false

  inst.entity:AddTransform()
  inst.entity:AddLight()

  inst.Light:SetIntensity(.8)
  inst.Light:SetColour(215 / 255, 205 / 255, 255 / 255)
  inst.Light:SetFalloff(.3)
  inst.Light:SetRadius(2)
  inst.Light:Enable(true)

  return inst
end

local PickUpMustTags = {"_inventoryitem"}
local PickUpCanTags = {
  "INLIMBO",
  "NOCLICK",
  "knockbackdelayinteraction",
  "catchable",
  "fire",
  "minesprung",
  "mineactive",
  "spider"
}
local PickUpForbidPrefabs = {
  spear = true,
  spear_wathgrithr = true,
  torch = true,
  axe = true,
  goldenaxe = true,
  pickaxe = true,
  goldenpickaxe = true,
  shovel = true,
  goldenshovel = true,
  hammer = true,
  multitool_axe_pickaxe = true,
  pitchfork = true,
  razor = true,
  featherpencil = true,
  fishingrod = true,
  oceanfishingrod = true,
  panflute = true,
  lantern = true,
  pumpkin_lantern = true,
  brush = true,
  farm_hoe = true,
  golden_farm_hoe = true,
  wateringcan = true,
  premiumwateringcan = true,
  tillweedsalve = true,
  seedpouch = true,
  compostingbin = true,
  plantregistryhat = true,
  nutrientsgoggleshat = true,
  trophyscale_oversizedveggies = true,
  book_horticulture = true,
  book_silviculture = true,
  fruitfly = true,
  lordfruitfly = true,
  friendlyfruitfly = true,
  fruitflyfruit = true,
  farm_soil_debris = true,
  soil_amender = true,
  soil_amender_fermented = true,
  compost = true,
  compostwrap = true,
  fertilizer = true,
  bugnet = true,
  trap = true,
  birdtrap = true,
  opalstaff = true,
  yellowstaff = true,
  chester_eyebone = true,
  glommerflower = true,
  lavae_egg = true,
  lavae_cocoon = true,
  glommerfuel = true,
  horn = true,
  heatrock = true,
  -- flint = true,
  bedroll_straw = true,
  tentaclespike = true,
  -- spidereggsack = true,
  wetgoop = true,
  spoiled_food = true,
  sketch = true,
  amulet = true,
  glommerwings = true,
  bernie_inactive = true,
  lighter = true,
  abigail_flower = true,
  lucy = true,
  reskin_tool = true,
  terrarium = true,
  tacklesketch = true,
  raincoat = true,
  sweatervest = true,
  reflectivevest = true,
  hawaiianshirt = true,
  beargervest = true,
  cane = true,
  mandrake = true,
  cookedmandrake = true,
  mandrakesoup = true,
  cookbook = true,
  fishingnet = true,
  rock_avocado_fruit = true,
  rock_avocado_fruit_sprout = true,
  moonrockseed = true
}
local PickUpForbidPattern = {
  "_tacklesketch",
  "_sketch",
  "deer_antler",
  "blowdart_",
  ".*hat$",
  "^armor.*",
  "trunkvest_",
  "oceanfishingbobber_"
}
local PickUpCD = 0.1

local function AutoPickup(inst, owner)
  if owner == nil or owner.components.inventory == nil then
    return
  end

  local x, y, z = owner.Transform:GetWorldPosition()
  local ents = TheSim:FindEntities(x, y, z, inst.pickUpRange, PickUpMustTags, PickUpCanTags)

  local ba = owner:GetBufferedAction()

  for i, v in ipairs(ents) do
    if
      v.components.inventoryitem ~= nil and v.components.inventoryitem.canbepickedup and
        v.prefab ~= nil and
        not PickUpForbidPrefabs[v.prefab] and
        (function()
          for _, pattern in ipairs(PickUpForbidPattern) do
            if string.match(v.prefab, pattern) ~= nil then
              return false
            end
          end
          return true
        end)() and
        v.components.inventoryitem.cangoincontainer and
        not v.components.inventoryitem:IsHeld() and
        owner.components.inventory:CanAcceptCount(v) >=
          (v.components.stackable ~= nil and v.components.stackable.stacksize or 1) and
        (ba == nil or ba.action ~= ACTIONS.PICKUP or ba.target ~= v)
     then
      if owner.components.minigame_participator ~= nil then
        local minigame = owner.components.minigame_participator:GetMinigame()
        if minigame ~= nil then
          minigame:PushEvent("pickupcheat", {cheater = owner, item = v})
        end
      end

      --Amulet will only ever pick up items one at a time. Even from stacks.
      SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

      -- inst.components.finiteuses:Use(1)

      -- local v_pos = v:GetPosition()
      -- if v.components.stackable ~= nil then
      --   v = v.components.stackable:Get()
      -- end

      -- if v.components.trap ~= nil and v.components.trap:IsSprung() then
      --   v.components.trap:Harvest(owner)
      -- else
      --   owner.components.inventory:GiveItem(v, nil, v_pos)
      -- end
      owner.components.inventory:GiveItem(v, nil, v:GetPosition())

      return
    end
  end
end

-- local sanityAmount = 5
-- local sanityHungerRate = 1.5
local function autoHealAndRefresh(inst, owner)
  if
    (owner.components.health and owner.components.health:IsHurt() and not owner.components.oldager) and
      (owner.components.hunger and
        owner.components.hunger.current > inst.peridicHealAmount * inst.healHungerRate)
   then
    owner.components.health:DoDelta(inst.peridicHealAmount)
    owner.components.hunger:DoDelta(-inst.peridicHealAmount * inst.healHungerRate)
  end

  -- if
  --   (owner.components.sanity and owner.components.sanity:IsInsane()) and
  --     (owner.components.hunger and owner.components.hunger.current > sanityAmount * sanityHungerRate)
  --  then
  --   owner.components.sanity:DoDelta(sanityAmount)
  --   owner.components.hunger:DoDelta(-sanityAmount * sanityHungerRate)
  -- end
end

local function OnRemoveEntity(inst)
  inst._light:Remove()
end

local function OnDropped(inst)
  inst._light.Light:Enable(true)
end

local function OnPutInInventory(inst)
  inst._light.Light:Enable(true)
end

local function slowDown(player, target, slow_mult, duration)
  if
    player and target and player.components.combat:IsValidTarget(target) and
      target.components.locomotor
   then
    if target:HasTag("epic") then
      slow_mult = 1 - ((1 - slow_mult) * 0.2)
    end

    target.components.locomotor:SetExternalSpeedMultiplier(player, "senhai", slow_mult)
    player:DoTaskInTime(
      duration,
      function()
        pcall(
          function()
            target.components.locomotor:RemoveExternalSpeedMultiplier(player, "senhai")
          end
        )
      end
    )
  end
end

local function FastRunOn(player, amount)
  pcall(
    function()
      local lc = player.components.locomotor
      lc.runspeed = lc.runspeed + amount
      lc.walkspeed = lc.walkspeed + amount
    end
  )
end
local function FastRunOff(player, amount)
  pcall(
    function()
      local lc = player.components.locomotor
      lc.runspeed = lc.runspeed - amount
      lc.walkspeed = lc.walkspeed - amount
    end
  )
end

local function FastRun(player, amount)
  FastRunOn(player, amount)

  player:DoTaskInTime(
    0.5,
    function()
      FastRunOff(player, amount)
    end
  )
end

local function calcHealthDrain(inst, attacker, target)
  return (inst.components.weapon.damage * 0.8 + attacker.components.combat.defaultdamage * 0.75 +
    target.components.combat.defaultdamage * 0.05) *
    (target:HasTag("epic") and 1.2 or 0.6) *
    (attacker.components.health:GetPercent() < 0.2 and 1.5 or 1) *
    0.015 *
    inst.healthSteelRatio
end

local function onattack(inst, attacker, target) -- inst, attacker, target, skipsanity
  --加入冰杖效果
  inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")

  if not target:IsValid() then
    return
  end

  -- 熄火
  if target.components.burnable ~= nil then
    if target.components.burnable:IsBurning() then
      target.components.burnable:Extinguish()
    elseif target.components.burnable:IsSmoldering() then
      target.components.burnable:SmotherSmolder()
    end
  end

  if target.components.combat then
    -- 吸血
    attacker.components.health:DoDelta(calcHealthDrain(inst, attacker, target))
    -- 吸血鬼的拥抱
    if math.random() > 0.5 and #AllPlayers > 1 then
      for _, other_player in ipairs(AllPlayers) do
        if
          other_player ~= attacker and not other_player:HasTag("playerghost") and
            attacker.components.sanity.current > 10 and
            other_player.components.health and
            not other_player.components.oldager and
            other_player.Transform and
            other_player.components.combat and
            other_player.components.health:IsHurt() and
            (other_player.components.health:GetPercent() < 0.5 or
              other_player.components.health.currenthealth < 100) and
            not other_player.components.health:IsDead() and
            attacker:GetDistanceSqToInst(other_player) < 900
         then
          ---@diagnostic disable-next-line: redundant-parameter
          attacker.components.talker:Say("吸血鬼的拥抱")
          attacker.components.sanity:DoDelta(-10)
          attacker.components.hunger:DoDelta(-10)

          local HOT =
            attacker:DoPeriodicTask(
            0.1,
            function()
              other_player.components.health:DoDelta(1)
            end
          )
          attacker:DoTaskInTime(
            5,
            function()
              HOT:Cancel()
            end
          )
        end
      end
    end
    -- 减速
    slowDown(attacker, target, 1 - inst.slowingRate, 2)
    -- 几率 AOE
    if TUNING.SenHai.storm_chance > 0 and math.random(0, 100) > (100 - TUNING.SenHai.storm_chance) then
      ---@diagnostic disable-next-line: redundant-parameter
      attacker.components.talker:Say("风暴！")

      local stormHitCount = 0

      local x, y, z = target.Transform:GetWorldPosition()
      local ents = TheSim:FindEntities(x, y, z, TUNING.SenHai.storm_range + inst.storm_extra_range)

      for k, v in pairs(ents) do
        if
          v ~= target and v:IsValid() and v.components.combat and
            attacker.components.combat:IsValidTarget(v) and
            v:HasTag("monster") and
            not v:HasTag("wall") and
            string.find(v.prefab, "wall") == nil
         then
          stormHitCount = stormHitCount + 1
          SpawnPrefab("explode_reskin").Transform:SetPosition(v.Transform:GetWorldPosition())
          -- SpawnPrefab("maxwell_smoke").Transform:SetPosition(v.Transform:GetWorldPosition())
          -- AOE damage
          v.components.combat:GetAttacked(
            attacker,
            attacker.components.combat:CalcDamage(v, inst, TUNING.SenHai.storm_damage_ratio),
            inst
          )
          -- 少量附带吸血
          attacker.components.health:DoDelta(
            calcHealthDrain(inst, attacker, v) * TUNING.SenHai.storm_damage_ratio * 0.25
          )
          -- 群体减速
          slowDown(attacker, v, (1 - inst.slowingRate) * 1.1, 2)
        end
      end

      while attacker.components.combat:IsValidTarget(target) and stormHitCount < 2 do
        target.components.combat:GetAttacked(
          attacker,
          attacker.components.combat:CalcDamage(target, inst),
          inst
        )
        stormHitCount = stormHitCount + 1

        FastRun(attacker, inst.speedUpAmount)
      end
    end
    -- gain exp
    pcall(
      function()
        if attacker.components.achievementmanager then
          local old_say = attacker.components.talker.Say
          attacker.components.talker.Say = function()
          end
          attacker.components.achievementmanager:sumexp(
            attacker,
            (target:HasTag("epic") and 3 or 1) * inst.expFromHit
          )
          attacker.components.talker.Say = old_say
        end
      end
    )
  end
end

local LevelUpTable = {
  5,
  10,
  20,
  30,
  50,
  100
}

setmetatable(
  LevelUpTable,
  {
    __index = function(t, k)
      if type(k) == "number" then
        return math.floor(
          -6272.28633138961 + 2173.55677536105 * k - 277.323154161138 * math.pow(k, 2) +
            15.7574193960469 * math.pow(k, 3) -
            0.263861525485163 * math.pow(k, 4)
        )
      else
        return nil
      end
    end
  }
)

local function ReportLevel(inst, player, extra)
  extra = extra or ""

  player.components.talker:Say(
    "等级:   " .. inst.level .. "\n经验: " .. inst.exp .. " / " .. LevelUpTable[inst.level + 1] .. extra
  )
end

local function OnRefuseItem(inst, giver, item)
  if item then
    ReportLevel(inst, giver)
  end
end

local function AcceptTest(inst, item)
  return item and item.prefab ~= nil
end

local function OnGetItemFromPlayer(inst, giver, item)
  if item and item.prefab ~= nil then
    local exp_get = WeaponExpTable[item.prefab]
    inst.exp = inst.exp + exp_get
    ReportLevel(inst, giver, "  +" .. exp_get)

    while inst.exp >= LevelUpTable[inst.level + 1] do
      inst.exp = inst.exp - LevelUpTable[inst.level + 1]
      inst.level = inst.level + 1
      ReportLevel(inst, giver, "  +" .. exp_get)
    end
  end

  inst.pickUpRange = math.min(15, 4 + inst.level * 0.5)

  inst.peridicHealCD = math.max(1, 10 - inst.level * 0.5)
  inst.peridicHealAmount = 2 + math.floor((inst.level + 5) * 0.5)
  inst.healHungerRate = math.max(1.2, 1.6 - inst.level * 0.02)

  inst.healthSteelRatio = 0.1 + 0.1 * (inst.level + 1)
  inst.slowingRate = math.min(0.990, 0.1 + (inst.level + 5) * 0.01)
  inst.expFromHit = 5 + inst.level * 3

  inst.speedUpAmount = math.min(4, 0.5 + inst.level * 0.06)

  inst.components.tool:SetAction(ACTIONS.CHOP, math.min(20, 1 + inst.level * 0.5))
  inst.components.tool:SetAction(ACTIONS.MINE, math.min(20, 1 + inst.level * 0.5))

  inst.components.weapon:SetDamage(TUNING.SenHai.damage + inst.level * 5)
  inst.components.weapon:SetRange(
    TUNING.SenHai.range + math.min(10, inst.level * 0.2),
    TUNING.SenHai.range + math.min(12, 0.5 * (inst.level + 2))
  )

  inst.storm_extra_range = math.min(9, inst.level * 0.3)

  inst.components.equippable.walkspeedmult =
    math.min(2.55, math.floor(TUNING.CANE_SPEED_MULT * (100 + inst.level * 5)) / 100)
  inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED * math.min(3, 1 + inst.level * 0.04)

  if giver ~= nil and item ~= nil then
    local OtherItems = giver.components.inventory:GetActiveItem()
    if
      OtherItems and OtherItems.prefab == item.prefab and OtherItems.components.stackable ~= nil and
        OtherItems.components.stackable.stacksize >= 1
     then
      inst.components.trader:AcceptGift(giver, OtherItems, 1)
    end
  end
end

local function onEquip(inst, owner) --装备
  OnGetItemFromPlayer(inst)
  owner.AnimState:OverrideSymbol("swap_object", "swap_senhai", "swap_senhai")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")

  inst.task_pick = inst:DoPeriodicTask(PickUpCD, AutoPickup, nil, owner)
  inst.task_heal = inst:DoPeriodicTask(inst.peridicHealCD, autoHealAndRefresh, nil, owner)
end

local function onUnequip(inst, owner) --解除装备
  owner.AnimState:Hide("ARM_carry")
  owner.AnimState:Show("ARM_normal")

  if inst.task_pick ~= nil then
    inst.task_pick:Cancel()
    inst.task_pick = nil
  end

  if inst.task_heal ~= nil then
    inst.task_heal:Cancel()
    inst.task_heal = nil
  end
end

local function onsave(inst, data)
  data.level = inst.level
  data.exp = inst.exp
end

local function onpreload(inst, data)
  if data then
    if data.level then
      inst.level = data.level
    end
    if data.exp then
      inst.exp = data.exp
    end

    OnGetItemFromPlayer(inst)
  end
end

local function fn()
  local inst = CreateEntity()

  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("senhai") --地上动画
  inst.AnimState:SetBuild("senhai")
  inst.AnimState:PlayAnimation("idle")

  inst._light = CreateLight()
  inst._light.entity:SetParent(inst.entity)

  -- inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
  -- inst:AddTag("pointy")

  -- inst:AddTag("irreplaceable")

  inst:AddTag("icestaff")
  inst:AddTag("extinguisher")

  inst.entity:SetPristine()

  inst.level = 0
  inst.exp = 0

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("tradable")
  inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
  inst:AddComponent("equippable")

  inst:AddComponent("weapon")
  inst.components.weapon:SetProjectile("ice_projectile")

  inst.components.weapon:SetOnAttack(onattack)
  -- inst.components.weapon.onattack = onattack

  inst:AddComponent("tool")

  inst.components.inventoryitem.atlasname = "images/inventoryimages/senhai.xml" --物品贴图

  inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

  inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
  inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

  inst.components.equippable:SetOnEquip(onEquip)
  inst.components.equippable:SetOnUnequip(onUnequip)

  inst.OnRemoveEntity = OnRemoveEntity

  -- MakeHauntableLaunch(inst)

  inst:ListenForEvent("equipped", OnGetItemFromPlayer)

  inst:AddComponent("trader")
  inst.components.trader:SetAcceptTest(AcceptTest)
  inst.components.trader.onaccept = OnGetItemFromPlayer
  inst.components.trader.onrefuse = OnRefuseItem

  inst.OnSave = onsave
  inst.OnPreLoad = onpreload

  return inst
end

return Prefab("senhai", fn, assets, {})
