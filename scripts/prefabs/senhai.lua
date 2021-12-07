local assets = {
  Asset("ANIM", "anim/senhai.zip"), --地上的动画
  Asset("ANIM", "anim/swap_senhai.zip"),
  Asset("ATLAS", "images/inventoryimages/senhai.xml") --加载物品栏贴图
}

local function ResetLight(inst, i, f, r)
  inst.Light:SetIntensity(i)
  inst.Light:SetColour(215 / 255, 205 / 255, 255 / 255)
  inst.Light:SetFalloff(f)
  inst.Light:SetRadius(r)
  inst.Light:Enable(true)
end

local function CreateLight()
  local temp = CreateEntity()

  temp:AddTag("FX")
  temp:AddTag("playerlight")
  --[[Non-networked entity]]
  temp.entity:SetCanSleep(false)
  temp.persists = false

  temp.entity:AddTransform()
  temp.entity:AddLight()

  ResetLight(temp, .92, 1.2, 2)

  return temp
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
  chester_eyebone = true,
  glommerflower = true,
  lavae_egg = true,
  lavae_cocoon = true,
  glommerfuel = true,
  horn = true,
  heatrock = true,
  -- flint = true,
  bedroll_straw = true,
  bedroll_furry = true,
  featherfan = true,
  tentaclespike = true,
  batbat = true,
  nightsword = true,
  ruins_bat = true,
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
  mast_item = true,
  mast_malbatross_item = true,
  malbatross_feathered_weave = true,
  oar = true,
  oar_driftwood = true,
  miniflare = true,
  saltbox = true,
  saddlehorn = true,
  saddle_basic = true,
  reviver = true,
  diviningrod = true,
  grass_umbrella = true,
  umbrella = true,
  waterballoon = true,
  compass = true,
  onemanband = true,
  mapscroll = true,
  waxwelljournal = true,
  book_gardening = true,
  book_birds = true,
  book_sleep = true,
  book_tentacles = true,
  book_brimstone = true,
  thurible = true,
  saddle_war = true,
  saddle_race = true,
  trap_teeth = true,
  beemine = true,
  boomerang = true,
  trap_teeth_maxwell = true,
  beemine_maxwell = true,
  rock_avocado_fruit = true,
  rock_avocado_fruit_sprout = true,
  moonrockseed = true,
  bullkelp_beachedroot = true,
  beef_bell = true,
  moonrockidol = true,
  blueprint = true,
  tacklecontainer = true,
  supertacklecontainer = true
}
local PickUpForbidPattern = {
  "staff",
  "_tacklesketch",
  "_sketch",
  "deer_antler",
  "blowdart_",
  ".*hat$",
  "^armor.*",
  "trunkvest_",
  "oceanfishingbobber_",
  "_blueprint"
}
local PickUpCD = 0.1

local function AutoPickup(inst, owner)
  if owner == nil or owner.components.inventory == nil then
    return
  end

  local x, y, z = owner.Transform:GetWorldPosition()
  local ents = TheSim:FindEntities(x, y, z, inst.pick_up_range, PickUpMustTags, PickUpCanTags)

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

      SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

      owner.components.inventory:GiveItem(v, nil, v:GetPosition())

      return
    end
  end
end

local function autoHealAndRefresh(inst, owner)
  if
    (owner.components.health and owner.components.health:IsHurt() and not owner.components.oldager) and
      (owner.components.health:GetMaxWithPenalty() - owner.components.health.currenthealth >=
        inst.peridic_heal_amount) and
      (owner.components.hunger and
        owner.components.hunger.current > inst.peridic_heal_amount * inst.heal_hunger_rate)
   then
    owner.components.health:DoDelta(inst.peridic_heal_amount)
    owner.components.hunger:DoDelta(-inst.peridic_heal_amount * inst.heal_hunger_rate)
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

local function slowDownTarget(player, target, slow_mult, duration)
  if
    player and target and player.components.combat:IsValidTarget(target) and
      target.components.locomotor
   then
    if target:HasTag("epic") then
      -- Boss has 1/3 effect
      slow_mult = 1 - ((1 - slow_mult) * 0.33)
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

local function BoostOn(player, amount)
  pcall(
    function()
      local lc = player.components.locomotor
      lc.runspeed = lc.runspeed + amount
      lc.walkspeed = lc.walkspeed + amount
    end
  )
end
local function BoostOff(player, amount)
  pcall(
    function()
      local lc = player.components.locomotor
      lc.runspeed = lc.runspeed - amount
      lc.walkspeed = lc.walkspeed - amount
    end
  )
end

local function BoostSpeed(player, amount)
  BoostOn(player, amount)

  player:DoTaskInTime(
    0.75,
    function()
      BoostOff(player, amount)
    end
  )
end

local function calcHealthDrain(inst, attacker, target)
  return (inst.components.weapon.damage + attacker.components.combat.defaultdamage) *
    -- target.components.combat.defaultdamage * 0.05) *
    -- (target:HasTag("epic") and 1.2 or 0.6) *
    (attacker.components.health:GetPercent() < 0.2 and 1.5 or 1) *
    inst.health_steel_ratio
end

local function onattack(inst, attacker, target) -- inst, attacker, target, skipsanity
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
    -- E1 吸血
    attacker.components.health:DoDelta(calcHealthDrain(inst, attacker, target))
    -- E2 吸血鬼的拥抱
    if #AllPlayers > 1 and math.random(0, 100) > inst.shadow_healing_chance then
      for _, other_player in ipairs(AllPlayers) do
        if
          other_player ~= attacker and not other_player:HasTag("playerghost") and
            attacker.components.sanity.current > inst.shadow_healing_cost and
            attacker.components.hunger.current > inst.shadow_healing_cost and
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
          attacker.components.talker:Say("吸血鬼的拥抱！")

          attacker.components.sanity:DoDelta(-inst.shadow_healing_cost)
          attacker.components.hunger:DoDelta(-inst.shadow_healing_cost)

          SpawnPrefab("collapse_small").Transform:SetPosition(
            other_player.Transform:GetWorldPosition()
          )

          local HOT =
            attacker:DoPeriodicTask(
            0.1,
            function()
              other_player.components.health:DoDelta(inst.shadow_healing_amount)
            end
          )
          attacker:DoTaskInTime(
            1.2,
            function()
              HOT:Cancel()
            end
          )
        end
      end
    end
    -- E3 减速
    slowDownTarget(attacker, target, 1 - inst.slowing_rate, inst.slowing_duration)
    -- E4 几率 AOE
    if inst.storm_chance > 0 and math.random(0, 100) > (100 - inst.storm_chance) then
      ---@diagnostic disable-next-line: redundant-parameter
      attacker.components.talker:Say("风暴！")

      local stormHitCount = 0

      local x, y, z = target.Transform:GetWorldPosition()
      local ents = TheSim:FindEntities(x, y, z, inst.storm_range)

      for _, v in pairs(ents) do
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
            attacker.components.combat:CalcDamage(v, inst, inst.storm_damage_ratio),
            inst
          )
          -- 附带少量吸血 (1/4)
          attacker.components.health:DoDelta(
            calcHealthDrain(inst, attacker, v) * inst.storm_damage_ratio * 0.25
          )
          -- 群体减速
          slowDownTarget(attacker, v, (1 - inst.slowing_rate) * 1.1, inst.slowing_duration)
        end
      end

      while attacker.components.combat:IsValidTarget(target) and stormHitCount < 2 do
        target.components.combat:GetAttacked(
          attacker,
          attacker.components.combat:CalcDamage(target, inst),
          inst
        )
        stormHitCount = stormHitCount + 1

        BoostSpeed(attacker, inst.boost_speed_amount)
      end
    end
    -- E5 gain exp
    pcall(
      function()
        if attacker.components.achievementmanager and attacker.components.achievementmanager.sumexp then
          local old_say = attacker.components.talker.Say
          attacker.components.talker.Say = function()
          end

          attacker.components.achievementmanager:sumexp(
            attacker,
            (target:HasTag("epic") and 3 or 1) * inst.exp_from_hit
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
        -- return math.floor(
        --   -6272.28633138961 + 2173.55677536105 * k - 277.323154161138 * math.pow(k, 2) +
        --     15.7574193960469 * math.pow(k, 3) -
        --     0.263861525485163 * math.pow(k, 4)
        -- )
        return math.floor(25 * math.pow(k, 2) - 325 * k + 1250)
      else
        return nil
      end
    end
  }
)

local function ReportLevel(inst, player, extra)
  extra = extra or ""

  player.components.talker:Say(
    "等级:   " ..
      inst.level:value() ..
        "\n经验: " .. inst.exp .. " / " .. LevelUpTable[inst.level:value() + 1] .. extra
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

local function GetPropertyWithLevel(level)
  return {
    pick_up_range = math.min(15, 2 + level * 0.3),
    storm_chance = math.min(90, 10 + level * 2), -- 0~100
    storm_range = 2 + math.min(12, level * 0.25),
    storm_damage_ratio = math.min(2.0, 0.1 + level * 0.025), -- 0.0~1.0
    peridic_heal_cd = math.max(1, 15 - level * 0.4),
    peridic_heal_amount = 1 + math.floor(level * 0.2),
    heal_hunger_rate = math.max(1.05, 1.6 - level * 0.01),
    shadow_healing_chance = math.min(50, 5 + level * 0.65), -- 0~100
    shadow_healing_amount = math.min(10, 1 + level * 0.2),
    shadow_healing_cost = math.max(5, 10 - level * 0.12),
    health_steel_ratio = math.min(0.75, (0.5 + 0.1 * (level + 1)) * 0.016),
    slowing_rate = math.min(0.990, 0.1 + (level + 5) * 0.01),
    slowing_duration = math.min(6, 0.75 + level * 0.1),
    exp_from_hit = 5 + level * 3,
    boost_speed_amount = math.min(4, 0.5 + level * 0.175),
    chop_power = math.min(20, 1 + level * 0.5),
    mine_power = math.min(20, 1 + level * 0.5),
    oar_power = math.min(0.98, 0.2 + level * 0.01),
    oar_max_velocity = math.min(15, 2 + level * 0.02),
    damage = 12 + level * 3,
    range_base = 1.5 + math.min(10, level * 0.2),
    range_escape = 2.5 + math.min(12, 0.5 * level),
    walkspeedmult = math.min(2.55, math.floor(TUNING.CANE_SPEED_MULT * (100 + level * 4)) / 100),
    dapperness = TUNING.DAPPERNESS_MED * math.min(3, 0.5 + level * 0.06),
    light_radius = math.min(32, 2 + level * 1.5),
    light_falloff = math.max(0.8, 1.2 - level * 0.01),
    light_intensity = math.min(0.97, 0.92 + level * 0.00125)
  }
end

local function OnGetItemFromPlayer(inst, giver, item)
  if item and item.prefab ~= nil then
    local exp_get = WeaponExpTable[item.prefab]
    if type(exp_get) == "function" then
      exp_get = exp_get()
    end

    inst.exp = inst.exp + exp_get
    ReportLevel(inst, giver, "  +" .. exp_get)

    while inst.exp >= LevelUpTable[inst.level:value() + 1] do
      -- while debug
      -- print(
      --   "[while debug] ",
      --   "[giver]",
      --   giver,
      --   "[item]",
      --   item,
      --   "[exp_get]",
      --   exp_get,
      --   "[inst.exp]",
      --   inst.exp,
      --   "[inst.level]",
      --   inst.level:value(),
      --   "[LevelUpTable[inst.level+1]]",
      --   LevelUpTable[inst.level:value() + 1]
      -- )

      inst.exp = inst.exp - LevelUpTable[inst.level:value() + 1]
      inst.level:set(inst.level:value() + 1)

      inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")

      ReportLevel(inst, giver, "  +" .. exp_get)
    end
  end

  local properties = GetPropertyWithLevel(inst.level:value())

  inst.pick_up_range = properties.pick_up_range

  inst.peridic_heal_cd = properties.peridic_heal_cd
  inst.peridic_heal_amount = properties.peridic_heal_amount
  inst.heal_hunger_rate = properties.heal_hunger_rate

  inst.health_steel_ratio = properties.health_steel_ratio

  inst.slowing_rate = properties.slowing_rate
  inst.slowing_duration = properties.slowing_duration

  inst.exp_from_hit = properties.exp_from_hit

  inst.boost_speed_amount = properties.boost_speed_amount

  inst.components.tool:SetAction(ACTIONS.CHOP, properties.chop_power)
  inst.components.tool:SetAction(ACTIONS.MINE, properties.mine_power)

  inst.components.oar.force = properties.oar_power
  inst.components.oar.max_velocity = properties.oar_max_velocity

  inst.components.weapon:SetDamage(properties.damage)
  inst.components.weapon:SetRange(properties.range_base, properties.range_escape)

  inst.storm_chance = properties.storm_chance
  inst.storm_range = properties.storm_range
  inst.storm_damage_ratio = properties.storm_damage_ratio

  inst.shadow_healing_chance = properties.shadow_healing_chance
  inst.shadow_healing_amount = properties.shadow_healing_amount
  inst.shadow_healing_cost = properties.shadow_healing_cost

  inst.components.equippable.walkspeedmult = properties.walkspeedmult
  inst.components.equippable.dapperness = properties.dapperness

  ResetLight(
    inst._light,
    properties.light_intensity,
    properties.light_falloff,
    properties.light_radius
  )

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
  inst.task_heal = inst:DoPeriodicTask(inst.peridic_heal_cd, autoHealAndRefresh, nil, owner)
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
  data.level = inst.level:value()
  data.exp = inst.exp
end

local function onpreload(inst, data)
  if data then
    if data.level then
      inst.level:set(data.level)
    end
    if data.exp then
      inst.exp = data.exp
    end

    OnGetItemFromPlayer(inst)
  end
end

local function OnLevelChange(inst)
  -- run on local
  local properties = GetPropertyWithLevel(inst.level:value())
  ResetLight(
    inst._light,
    properties.light_intensity,
    properties.light_falloff,
    properties.light_radius
  )
end

local function DisplayNameFx(inst)
  local lv = inst.level:value()
  local props = GetPropertyWithLevel(lv)

  local name_with_lv = inst.name .. "  Lv: " .. lv
  local slowing =
    "攻击减速: " ..
    string.format("%.1f", props.slowing_rate * 100) ..
      "% (持续: " .. string.format("%.1f", props.slowing_duration) .. "秒)"
  local pick_range = "拾取范围: " .. string.format("%.1f", props.pick_up_range)
  local life_regen =
    "生命回复: " ..
    string.format("%.1f", props.peridic_heal_amount) ..
      "/" ..
        string.format("%.1f", props.peridic_heal_cd) ..
          "秒 (饥饿消耗 1:" .. string.format("%.2f", props.heal_hunger_rate) .. ")"
  local life_steel = "吸血: " .. string.format("%.1f", props.health_steel_ratio * 100) .. "%"
  -- local light_desc = "照明范围: " .. string.format("%.0f", props.light_radius)
  local storm =
    "风暴: " ..
    string.format("%.0f", props.storm_chance) ..
      "% 几率对范围 " ..
        string.format("%.1f", props.storm_range) ..
          " 敌人造成 " .. string.format("%.0f", props.storm_damage_ratio * 100) .. "% 伤害"

  return name_with_lv ..
    "\n" ..
      slowing ..
        "\n" ..
          pick_range ..
            "\n" ..
              life_steel ..
                "\n" .. -- .. light_desc
                  "\n" .. life_regen .. "\n" .. storm
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

  -- inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
  -- inst:AddTag("pointy")

  -- inst:AddTag("irreplaceable")

  inst:AddTag("allow_action_on_impassable")

  inst:AddTag("icestaff")
  inst:AddTag("extinguisher")
  -- inst:AddTag("waterproofer")

  MakeInventoryFloatable(inst, "small", nil, 0.68)

  inst.entity:SetPristine()

  inst.level = net_ushortint(inst.GUID, "senhai._level", "leveldirty")
  inst.level:set(0)

  inst.exp = 0

  inst._light = CreateLight()
  inst._light.entity:SetParent(inst.entity)

  inst.displaynamefn = DisplayNameFx

  if not TheWorld.ismastersim then
    inst:ListenForEvent("leveldirty", OnLevelChange)

    return inst
  end

  -- inst:AddComponent("tradable")
  inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
  inst:AddComponent("equippable")

  inst:AddComponent("weapon")
  inst.components.weapon:SetProjectile("ice_projectile")

  inst.components.weapon:SetOnAttack(onattack)
  -- inst.components.weapon.onattack = onattack

  inst:AddComponent("tool")

  inst:AddComponent("oar")

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
