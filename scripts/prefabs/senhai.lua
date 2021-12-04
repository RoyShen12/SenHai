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
  heatrock = true
}
local PickUpRange = 10
local pickUpCD = 0.1

local function autoPickup(inst, owner)
  if owner == nil or owner.components.inventory == nil then
    return
  end

  local x, y, z = owner.Transform:GetWorldPosition()
  local ents = TheSim:FindEntities(x, y, z, PickUpRange, PickUpMustTags, PickUpCanTags)

  local ba = owner:GetBufferedAction()

  for i, v in ipairs(ents) do
    if
      v.components.inventoryitem ~= nil and v.components.inventoryitem.canbepickedup and
        v.prefab ~= nil and
        not PickUpForbidPrefabs[v.prefab] and
        v.components.inventoryitem.cangoincontainer and
        not v.components.inventoryitem:IsHeld() and
        owner.components.inventory:CanAcceptCount(v, 1) > 0 and
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

      local v_pos = v:GetPosition()
      if v.components.stackable ~= nil then
        v = v.components.stackable:Get()
      end

      if v.components.trap ~= nil and v.components.trap:IsSprung() then
        v.components.trap:Harvest(owner)
      else
        owner.components.inventory:GiveItem(v, nil, v_pos)
      end

      return
    end
  end
end

local refreshCD = 2
local healAmount = 5
local healHungerRate = 1.2
-- local sanityAmount = 5
-- local sanityHungerRate = 1.5
local function autoHealAndRefresh(inst, owner)
  if
    (owner.components.health and owner.components.health:IsHurt() and not owner.components.oldager) and
      (owner.components.hunger and owner.components.hunger.current > healAmount * healHungerRate)
   then
    owner.components.health:DoDelta(healAmount)
    owner.components.hunger:DoDelta(-healAmount * healHungerRate)
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

local function onEquip(inst, owner) --装备
  owner.AnimState:OverrideSymbol("swap_object", "swap_senhai", "swap_senhai")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")

  inst.task_pick = inst:DoPeriodicTask(pickUpCD, autoPickup, nil, owner)
  inst.task_heal = inst:DoPeriodicTask(refreshCD, autoHealAndRefresh, nil, owner)
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

local function calcHealthDrain(inst, attacker, target)
  return (inst.components.weapon.damage * 0.8 + attacker.components.combat.defaultdamage * 0.75 +
    target.components.combat.defaultdamage * 0.05) *
    (target:HasTag("epic") and 1.2 or 0.6) *
    (attacker.components.health:GetPercent() < 0.2 and 1.5 or 1) *
    -- 0.015
    0.005
end

local function onattack(inst, attacker, target) -- inst, attacker, target, skipsanity
  --加入冰杖效果
  -- inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/obsidian_wetsizzles")

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
    if math.random() > 0.5 then
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
    slowDown(attacker, target, 0.6, 2)
    -- 几率 AOE
    if
      TUNING.SenHai.storm_chance > 0 and math.random(0, 100) > (100 - TUNING.SenHai.storm_chance) and
        attacker.components.combat:IsValidTarget(target)
     then
      ---@diagnostic disable-next-line: redundant-parameter
      attacker.components.talker:Say("风暴！")

      local x, y, z = target.Transform:GetWorldPosition()
      local ents = TheSim:FindEntities(x, y, z, TUNING.SenHai.storm_range)

      for k, v in pairs(ents) do
        if
          v ~= target and v:IsValid() and v.components.combat and
            attacker.components.combat:IsValidTarget(v) and
            string.find(v.prefab, "wall") == nil
         then
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
          slowDown(attacker, target, 0.65, 2)
        end
      end
    end
    -- exp
    pcall(
      function()
        if attacker.components.achievementmanager then
          local old_say = attacker.components.talker.Say
          attacker.components.talker.Say = function()
          end
          attacker.components.achievementmanager:sumexp(attacker, 5)
          attacker.components.talker.Say = old_say
        end
      end
    )
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

  inst:AddTag("irreplaceable")

  inst:AddTag("icestaff")
  inst:AddTag("extinguisher")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
  inst:AddComponent("equippable")

  inst:AddComponent("weapon")
  inst.components.weapon:SetDamage(TUNING.SenHai.damage)

  inst.components.weapon:SetRange(TUNING.SenHai.range, TUNING.SenHai.range + 2)
  inst.components.weapon:SetProjectile("ice_projectile")

  inst.components.weapon:SetOnAttack(onattack)
  -- inst.components.weapon.onattack = onattack

  inst:AddComponent("tool")
  inst.components.tool:SetAction(ACTIONS.CHOP, 4)
  inst.components.tool:SetAction(ACTIONS.MINE, 2)

  inst.components.inventoryitem.atlasname = "images/inventoryimages/senhai.xml" --物品贴图

  inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

  inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
  inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

  inst.components.equippable:SetOnEquip(onEquip)
  inst.components.equippable:SetOnUnequip(onUnequip)
  inst.components.equippable.walkspeedmult = math.floor(TUNING.CANE_SPEED_MULT * 125) / 100
  inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED

  inst.OnRemoveEntity = OnRemoveEntity

  -- MakeHauntableLaunch(inst)

  return inst
end

return Prefab("senhai", fn, assets, {})
