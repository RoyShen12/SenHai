local GetPropertyWithLevel = require("numerical").GetPropertyWithLevel
-- local SummonsList = require("senhai-constants").SummonsList
-- local SummonsNicknameList = require("senhai-constants").SummonsNicknameList
-- local summonRetargetFn = require("common-helper").summonRetargetFn
local MakeHealerSpiderDoHeal = require("common-helper").MakeHealerSpiderDoHeal
local PickUpForbidPrefabs = require("senhai-constants").PickUpForbidPrefabs
local PickUpForbidPattern = require("senhai-constants").PickUpForbidPattern
local PickUpCanNotTags = require("senhai-constants").PickUpCanNotTags
local PickPrefabs = require("senhai-constants").PickPrefabs
local SpiderBrain = require("brains/spiderbrain")
local slowDownTarget = require("common-helper").slowDownTarget
local gainExp = require("common-helper").gainExp
local isLocalKeyEventReady = require("common-helper").isLocalKeyEventReady
local ResetLight = require("common-helper").ResetLight
local DoSpikeAttack = require("common-helper").DoSpikeAttack

local assets = {
  Asset("ANIM", "anim/senhai.zip"),                   --地上的动画
  Asset("ANIM", "anim/swap_senhai.zip"),
  Asset("ATLAS", "images/inventoryimages/senhai.xml") --加载物品栏贴图
}

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

-- local function SummonAnimalBuddy(inst, owner)
--   local x, y, z = owner.Transform:GetWorldPosition()

--   local prefab = nil
--   local random = math.random()
--   for key, value in pairs(SummonsList) do
--     if random < value then
--       prefab = key
--       break
--     end
--   end

--   local summon = SpawnPrefab(prefab)

--   --#region summon construct

--   summon:AddTag("senhai_summons")

--   -------------------- fix leader
--   if summon.components.follower == nil then
--     summon:AddComponent("follower")
--   end

--   summon.components.follower:SetLeader(owner)
--   summon.components.follower.maxfollowtime = nil

--   -------------------- special logic for each tag
--   if summon:HasTag("hound") then
--     summon.Transform:SetScale(.32, .32, .32)
--     summon:AddTag("pet_hound")
--     summon.components.combat:SetRetargetFunction(3, summonRetargetFn)
--   end

--   if summon:HasTag("spider") then
--     summon.Transform:SetScale(.6, .6, .6)
--   end

--   if summon:HasTag("tallbird") then
--     summon.Transform:SetScale(.33, .33, .33)
--     summon.pending_spawn_smallbird = false
--     summon:SetBrain(SpiderBrain)
--     summon.components.combat:SetAreaDamage(
--       1.75,
--       0.333,
--       function(target, attacker)
--         return target:IsValid() and not target:IsInLimbo() and target.components.combat and
--             target.components.health and
--             not target.components.health:IsDead() and
--             (target:HasTag("monster") or target.components.combat.target == attacker or
--               target.components.combat.target == attacker.components.follower.leader or
--               target.prefab == attacker.components.combat.target) and
--             not target:HasTag("wall") and
--             string.find(target.prefab, "wall") == nil and
--             string.find(target.prefab, "fence") == nil
--       end
--     )
--     summon.components.combat:SetRetargetFunction(3, summonRetargetFn)
--   end

--   -------------------- special logic for each prefab
--   if summon.prefab == "spider" then
--     if summon.components.burnable then
--       summon.components.burnable.burntime = nil
--       summon.components.burnable.Ignite = function()
--       end
--     end

--     if summon.components.freezable then
--       summon.components.freezable:SetResistance(1000)
--       summon.components.freezable.Freeze = function()
--       end
--       summon.components.freezable.AddColdness = function()
--       end
--     end
--   end

--   if summon.prefab == "spider_dropper" then
--     local old_onhitotherfn = summon.components.combat.onhitotherfn
--     summon.components.combat.onhitotherfn = function(
--       attacker,
--       target,
--       damage,
--       stimuli,
--       weapon,
--       damageresolved)
--       if old_onhitotherfn ~= nil then
--         old_onhitotherfn(attacker, target, damage, stimuli, weapon, damageresolved)
--       end

--       if
--           target ~= nil and target:IsValid() and target.components.health and target.components.combat and
--           summon.components.combat:IsValidTarget(target) and
--           inst.summon_spider_dropper_poison_chance > 0 and
--           math.random(0, 100) > (100 - inst.summon_spider_dropper_poison_chance)
--       then
--         summon.components.talker:Say("剧毒之牙！")

--         local DOT =
--             summon:DoPeriodicTask(
--               0.1,
--               function()
--                 pcall(
--                   function()
--                     target.components.health:DoDelta(-inst.summon_spider_dropper_poison_damage, true)
--                   end
--                 )
--               end
--             )
--         summon:DoTaskInTime(
--           1,
--           function()
--             DOT:Cancel()
--           end
--         )
--       end
--     end
--   end

--   if summon.prefab == "spider_hider" then
--     summon.components.health.externalabsorbmodifiers:SetModifier(
--       owner,
--       0.25,
--       "senhai_spider_hider_extra"
--     )
--   end

--   if summon.prefab == "spider_spitter" then
--     summon.components.combat.externaldamagemultipliers:SetModifier(
--       owner,
--       1.18,
--       "senhai_spider_spitter_extra"
--     )
--   end

--   if summon.prefab == "spider_healer" then
--     summon.DoHeal = MakeHealerSpiderDoHeal(inst)
--   end

--   if summon.prefab == "hound" then
--     local leader = summon.components.follower.leader
--     leader.components.health:SetMaxHealth(leader.components.health.maxhealth + 100)
--     summon:ListenForEvent(
--       "onremove",
--       function()
--         leader.components.health:SetMaxHealth(leader.components.health.maxhealth - 100)
--       end
--     )
--   end

--   if summon.prefab == "icehound" then
--     local leader = summon.components.follower.leader
--     leader.components.sanity:SetMax(leader.components.sanity.max + 100)
--     summon:ListenForEvent(
--       "onremove",
--       function()
--         leader.components.sanity:SetMax(leader.components.sanity.max - 100)
--       end
--     )
--   end

--   -------------------- add tags for no internal conflict
--   if not summon:HasTag("spider") then
--     summon:AddTag("spiderdisguise")
--   end

--   if not summon:HasTag("hound") then
--     summon:AddTag("houndfriend")
--   end

--   -------------------- remove bad tags
--   if summon:HasTag("trader") then
--     summon:RemoveTag("trader")
--   end

--   if summon:HasTag("monster") then
--     summon:RemoveTag("monster")
--   end

--   if summon:HasTag("hostile") then
--     summon:RemoveTag("hostile")
--   end

--   summon.Transform:SetPosition(x + 1 * (math.random() - 0.5), y, z + 1 * (math.random() - 0.5))

--   -------------------- add talker
--   if summon.components.talker == nil then
--     summon:AddComponent("talker")
--     summon.components.talker.fontsize = 28
--     summon.components.talker.font = TALKINGFONT
--     summon.components.talker.offset = Vector3(0, -320, 0)
--   end

--   -------------------- burn & freeze huge resistance
--   -- if summon.components.burnable then
--   --   summon.components.burnable.burntime = nil
--   -- end

--   -- if summon.components.freezable then
--   --   summon.components.freezable:SetResistance(1000)
--   -- end

--   -------------------- remove components
--   if summon.components.halloweenmoonmutable ~= nil then
--     summon:RemoveComponent("halloweenmoonmutable")
--   end

--   if summon.components.trader ~= nil then
--     summon:RemoveComponent("trader")
--   end

--   if summon.components.sanityaura ~= nil then
--     summon:RemoveComponent("sanityaura")
--   end

--   if summon.components.hauntable ~= nil then
--     summon:RemoveComponent("hauntable")
--   end

--   if summon.components.leader ~= nil then
--     summon:RemoveComponent("leader")
--   end

--   if summon.components.homeseeker ~= nil then
--     summon:RemoveComponent("homeseeker")
--   end

--   -------------------- clear loots
--   if summon.components.lootdropper then
--     summon.components.lootdropper:SetLoot({})
--   end

--   -------------------- no eating meats
--   if summon.components.eater then
--     summon.components.eater:SetStrongStomach(false)
--     summon.components.eater:SetCanEatRawMeat(false)
--   end

--   -------------------- no sleep
--   if summon.components.sleeper then
--     summon.components.sleeper.watchlight = true
--     summon.components.sleeper:SetResistance(1000)
--     summon.components.sleeper:SetSleepTest(
--       function()
--         return false
--       end
--     )
--   end

--   summon.components.locomotor.walkspeed =
--       summon.components.locomotor.walkspeed + inst.summon_speed_addition +
--       (summon.prefab == "spider" and 4 or 0)
--   summon.components.locomotor.runspeed =
--       summon.components.locomotor.runspeed + inst.summon_speed_addition +
--       (summon.prefab == "spider" and 4 or 0)

--   summon.components.combat:SetDefaultDamage(
--     summon.components.combat.defaultdamage + inst.summon_damage_addition
--   )
--   summon.components.combat:SetAttackPeriod(
--     summon.components.combat.min_attack_period * inst.summon_attack_period_mutl
--   )
--   summon.components.combat.attackrange =
--       summon.components.combat.attackrange + inst.summon_extra_range

--   summon.components.combat.hitrange = summon.components.combat.hitrange + inst.summon_extra_range

--   summon.components.health:SetMaxHealth(
--     summon.components.health.maxhealth + inst.summon_health_addition +
--     (summon.prefab == "spider_warrior" and 500 or 0)
--   )
--   summon.components.health.externalabsorbmodifiers:SetModifier(
--     owner,
--     inst.summon_extra_armor,
--     "senhai_summon_base"
--   )

--   summon.components.health:StartRegen(
--     inst.summon_health_regen * (summon.prefab == "spider_warrior" and 2 or 1),
--     5,
--     false
--   )

--   if summon.components.named == nil then
--     summon:AddComponent("named")
--   end
--   summon.components.named:SetName(
--     (SummonsNicknameList[summon.prefab] or "") ..
--     "·" .. STRINGS.PIGNAMES[math.random(#STRINGS.PIGNAMES)] .. "  Lv: " .. inst.level:value()
--   )

--   --#endregion

--   summon:ListenForEvent(
--     "death",
--     function()
--       for index, ele in ipairs(inst.Summons) do
--         if ele == summon then
--           inst:DoTaskInTime(
--             inst.summon_cd,
--             function()
--               SummonAnimalBuddy(inst, owner)
--             end
--           )
--           return table.remove(inst.Summons, index)
--         end
--       end
--     end
--   )

--   table.insert(inst.Summons, summon)
-- end

-- local function clearOldSummons(leader)
--   print("clearOldSummons", leader)
--   for old_summon, is_follower in pairs(leader.components.leader.followers) do
--     print("followers loop old_summon", old_summon)
--     if old_summon:IsValid() and old_summon.components.follower.leader == leader then
--       -- local inArr = false
--       -- for _, summon in ipairs(inst.Summons) do
--       --   if summon == old_summon then
--       --     inArr = true
--       --   end
--       -- end
--       -- ---@diagnostic disable-next-line: undefined-field
--       -- if not inArr and table.contains(table.getkeys(SummonsList), old_summon.prefab) then
--       --   old_summon:Remove()
--       -- end
--       print("followers loop remove summon", old_summon)
--       old_summon:Remove()
--     end
--   end
-- end

-- local function spawnSummons(inst, owner)
--   clearOldSummons(owner)

--   while inst.SummonEnabled and #inst.Summons < inst.summon_amount do
--     SummonAnimalBuddy(inst, owner)
--   end
-- end

local PickUpMustTags = { "_inventoryitem" }
local PickUpCD = 0.1

local function autoPickup(inst, owner)
  if owner == nil or owner.components.inventory == nil then
    return
  end

  local x, y, z = owner.Transform:GetWorldPosition()
  local ents = TheSim:FindEntities(x, y, z, inst.pick_up_range, PickUpMustTags, PickUpCanNotTags)

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
          minigame:PushEvent("pickupcheat", { cheater = owner, item = v })
        end
      end

      SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

      owner.components.inventory:GiveItem(v, nil, v:GetPosition())

      return
    end
  end

  -- 懒人采摘
  if inst.pick_up_advance then
    ents = TheSim:FindEntities(x, y, z, inst.pick_up_range, {}, PickUpCanNotTags)
    ba = owner:GetBufferedAction()

    for i, v in ipairs(ents) do
      if
      ---@diagnostic disable-next-line: undefined-field
          table.contains(PickPrefabs, v.prefab) and v.components.pickable and
          v.components.pickable:CanBePicked() and
          (function()
            local empty = 0

            for j = 1, owner.components.inventory:GetNumSlots() do
              if owner.components.inventory:GetItemInSlot(j) == nil then
                empty = empty + 1
              end
            end

            local bag = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK)

            if bag and bag.components.container then
              local backCtn = bag.components.container

              for j = 1, backCtn:GetNumSlots() do
                if backCtn:GetItemInSlot(j) == nil then
                  empty = empty + 1
                end
              end
            end

            return empty >= 3
          end)() and
          (ba == nil or ba.action ~= ACTIONS.PICKUP or ba.target ~= v)
      then
        SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

        v.components.pickable:Pick(owner)
      end
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
      return
    elseif target.components.burnable:IsSmoldering() then
      target.components.burnable:SmotherSmolder()
      return
    end
  end

  if target.components.combat then
    -- E1 吸血
    attacker.components.health:DoDelta(calcHealthDrain(inst, attacker, target))

    -- E2 吸血鬼的拥抱
    if #AllPlayers > 1 and math.random(0, 100) > (100 - inst.shadow_healing_chance) then
      local shadow_healing_casted_count = 0

      for _, other_player in ipairs(AllPlayers) do
        if
            other_player and other_player:IsValid() and other_player ~= attacker and
            not other_player:HasTag("playerghost") and
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
            attacker:GetDistanceSqToInst(other_player) < 1200
        then
          shadow_healing_casted_count = shadow_healing_casted_count + 1
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
                  pcall(
                    function()
                      other_player.components.health:DoDelta(inst.shadow_healing_amount, true)
                      attacker.components.health:DoDelta(inst.shadow_healing_amount * 0.25, true)
                    end
                  )
                end
              )

          attacker:DoTaskInTime(
            1,
            function()
              HOT:Cancel()
            end
          )
        end
      end

      if shadow_healing_casted_count > 0 then
        local DOT =
            attacker:DoPeriodicTask(
              0.1,
              function()
                pcall(
                  function()
                    target.components.health:DoDelta(
                      -inst.shadow_healing_amount * shadow_healing_casted_count,
                      true
                    )
                  end
                )
              end
            )
        attacker:DoTaskInTime(
          1,
          function()
            DOT:Cancel()
          end
        )
      end
    end

    -- E3 减速
    slowDownTarget(attacker, target, 1 - inst.slowing_rate, inst.slowing_duration)

    -- E4 风暴
    if inst.storm_chance > 0 and math.random(0, 100) > (100 - inst.storm_chance) then
      ---@diagnostic disable-next-line: redundant-parameter
      attacker.components.talker:Say("风暴！")

      local stormHitCount = 0

      local x, y, z = target.Transform:GetWorldPosition()
      local ents =
          TheSim:FindEntities(
            x,
            y,
            z,
            inst.storm_range,
            { "_combat", "_health" },
            {
              "FX",
              "INLIMBO",
              "NOCLICK"
            }
          )

      for _, v in pairs(ents) do
        if
            v ~= target and v:IsValid() and not v:IsInLimbo() and v.components.combat and
            v.components.health and
            not v.components.health:IsDead() and
            attacker.components.combat:IsValidTarget(v) and
            (v:HasTag("monster") or v.components.combat.target == attacker or
              v.prefab == target.prefab) and
            not v:HasTag("wall") and
            string.find(v.prefab, "wall") == nil and
            string.find(v.prefab, "fence") == nil
        then
          stormHitCount = stormHitCount + 1

          SpawnPrefab("explode_reskin").Transform:SetPosition(v.Transform:GetWorldPosition())
          -- SpawnPrefa("maxwell_smoke").Transform:SetPosition(v.Transform:GetWorldPosition())

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
          -- gain exp (1/4)
          pcall(
            function()
              gainExp(attacker, inst.exp_from_hit * 0.25, v)
            end
          )

          -- if math.random(0, 100) > 80 then
          --   attacker.components.hunger:DoDelta(1)
          --   attacker.components.sanity:DoDelta(1)
          -- end
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
        gainExp(attacker, inst.exp_from_hit, target)
      end
    )

    -- E6 地刺
    if inst.spike_chance > 0 and math.random(0, 100) > (100 - inst.spike_chance) then
      DoSpikeAttack(
        attacker,
        target,
        math.random(inst.spike_amount_lower, inst.spike_amount_upper),
        inst.spike_damage,
        inst.spike_latency,
        inst.spike_radius * 1.2,
        inst.spike_radius
      )
    end
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
    "\n经验: " ..
    string.format("%.0f", inst.exp) .. " / " .. LevelUpTable[inst.level:value() + 1] .. extra
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

  local level = inst.level:value()

  local properties = GetPropertyWithLevel(level)

  inst.pick_up_advance = level >= 20

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
  inst.hammer_power = properties.hammer_power
  inst.dig_power = properties.dig_power

  inst.components.oar.force = properties.oar_power
  inst.components.oar.max_velocity = properties.oar_max_velocity

  inst.components.weapon:SetDamage(properties.damage)
  inst.components.weapon:SetRange(properties.range_base, properties.range_escape)

  inst.storm_chance = properties.storm_chance
  inst.storm_range = properties.storm_range
  inst.storm_damage_ratio = properties.storm_damage_ratio

  inst.spike_chance = properties.spike_chance
  inst.spike_amount_upper = properties.spike_amount_upper
  inst.spike_amount_lower = properties.spike_amount_lower
  inst.spike_damage = properties.spike_damage
  inst.spike_latency = properties.spike_latency
  inst.spike_radius = properties.spike_radius

  -- inst.summon_cd = properties.summon_cd
  -- inst.summon_amount = properties.summon_amount
  -- inst.summon_health_addition = properties.summon_health_addition
  -- inst.summon_damage_addition = properties.summon_damage_addition
  -- inst.summon_attack_period_mutl = properties.summon_attack_period_mutl
  -- inst.summon_speed_addition = properties.summon_speed_addition
  -- inst.summon_extra_armor = properties.summon_extra_armor
  -- inst.summon_extra_range = properties.summon_extra_range
  -- inst.summon_health_regen = properties.summon_health_regen
  -- inst.summon_spider_dropper_poison_chance = properties.summon_spider_dropper_poison_chance
  -- inst.summon_spider_dropper_poison_damage = properties.summon_spider_dropper_poison_damage

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

  -- owner:AddTag("spiderwhisperer")
  owner:AddTag("senhai_holder")

  owner.AnimState:OverrideSymbol("swap_object", "swap_senhai", "swap_senhai")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")

  inst.task_pick = inst:DoPeriodicTask(PickUpCD, autoPickup, nil, owner)
  inst.task_heal = inst:DoPeriodicTask(inst.peridic_heal_cd, autoHealAndRefresh, nil, owner)

  -- inst.Summons = {}
  -- inst:DoTaskInTime(
  --   1,
  --   function()
  --     spawnSummons(inst, owner)
  --   end
  -- )
end

local function onUnequip(inst, owner) --解除装备
  -- owner:RemoveTag("spiderwhisperer")
  owner:RemoveTag("senhai_holder")

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

  -- if inst.task_spawning ~= nil then
  --   inst.task_spawning:Cancel()
  --   inst.task_spawning = nil
  --   for _, summon in ipairs(inst.Summons) do
  --     inst:DoTaskInTime(
  --       math.random() * 0.5,
  --       function()
  --         summon:Remove()
  --       end
  --     )
  --   end
  --   inst.Summons = {}
  -- end
  -- for _, summon in ipairs(inst.Summons) do
  --   inst:DoTaskInTime(
  --     math.random() * 0.5,
  --     function()
  --       summon:Remove()
  --     end
  --   )
  -- end
  -- inst.Summons = {}
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
      "\n攻击减速: " ..
      string.format("%.0f", props.slowing_rate * 100) ..
      "% (持续: " .. string.format("%.1f", props.slowing_duration) .. "秒)"
  local pick_range = "\n懒人拾取范围: " .. string.format("%.1f", props.pick_up_range)

  local life_regen =
      "\n生命回复: " ..
      string.format("%.1f", props.peridic_heal_amount) ..
      "/" ..
      string.format("%.1f", props.peridic_heal_cd) ..
      "秒 (饥饿消耗 1:" .. string.format("%.2f", props.heal_hunger_rate) .. ")"
  local life_steel = "\n吸血: " .. string.format("%.1f", props.health_steel_ratio * 100) .. "%"

  -- local light_desc = "照明范围: " .. string.format("%.0f", props.light_radius)

  local storm =
      "\n" ..
      string.format("%.0f", props.storm_chance) ..
      "% 几率触发风暴，对范围 " ..
      string.format("%.1f", props.storm_range) ..
      " 敌人造成 " .. string.format("%.0f", props.storm_damage_ratio * 100) .. "% 伤害"

  local spike =
      "\n" ..
      string.format("%.0f", props.spike_chance) ..
      "% 几率生成 " ..
      props.spike_amount_lower ..
      "~" ..
      props.spike_amount_upper ..
      " 根地刺，延迟 " ..
      string.format("%.1f", props.spike_latency) ..
      " 秒后，每根对范围 " ..
      string.format("%.1f", props.spike_radius) ..
      " 敌人造成 " .. string.format("%.0f", props.spike_damage) .. " 伤害"

  local summon =
      props.summon_amount > 0 and
      ("\n召唤最多 " ..
        props.summon_amount ..
        " 个动物伙伴 (伙伴获得 " ..
        string.format("%.0f", props.summon_health_addition) ..
        " 额外生命、" ..
        string.format("%.0f", props.summon_damage_addition) ..
        " 额外伤害和 " ..
        string.format("%.0f", props.summon_extra_armor * 100) ..
        "% 伤害吸收)，复活CD " .. string.format("%.0f", props.summon_cd) .. " 秒") or
      ""

  return name_with_lv ..
      slowing .. pick_range .. life_steel .. life_regen .. storm .. spike -- .. summon
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

  TheInput:AddKeyDownHandler(
    KEY_END,
    function()
      if not isLocalKeyEventReady(inst) then
        return
      end

      SendModRPCToServer(MOD_RPC.senhai.TpToFriend, inst)
    end
  )

  -- TheInput:AddKeyDownHandler(
  --   KEY_T,
  --   function()
  --     if not isLocalKeyEventReady(inst) then
  --       return
  --     end

  --     SendModRPCToServer(MOD_RPC.senhai.SwitchSummon, inst)
  --   end
  -- )

  TheInput:AddKeyDownHandler(
    KEY_O,
    function()
      if not isLocalKeyEventReady(inst) then
        return
      end

      SendModRPCToServer(MOD_RPC.senhai.SwitchHammerAndShovel, inst)
    end
  )

  if not TheWorld.ismastersim then
    inst:ListenForEvent("leveldirty", OnLevelChange)

    return inst
  end

  -- inst.Summons = {}
  -- inst.SummonEnabled = true

  -- inst:AddComponent("tradable")
  inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
  inst:AddComponent("equippable")

  inst:AddComponent("weapon")
  inst.components.weapon:SetProjectile("senhai_projectile")

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
  inst.components.trader.acceptnontradable = true
  inst.components.trader:SetAcceptTest(AcceptTest)
  inst.components.trader.onaccept = OnGetItemFromPlayer
  inst.components.trader.onrefuse = OnRefuseItem

  inst.OnSave = onsave
  inst.OnPreLoad = onpreload

  return inst
end

return Prefab("senhai", fn, assets, {})
