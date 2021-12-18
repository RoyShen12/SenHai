local function HasFriendlyLeader(inst, target)
  local leader = inst.components.follower.leader

  local target_leader =
    (target.components.follower ~= nil) and target.components.follower.leader or nil

  if leader ~= nil and target_leader ~= nil then
    if target_leader.components.inventoryitem then
      target_leader = target_leader.components.inventoryitem:GetGrandOwner()
      if target_leader == nil then
        return true
      end
    end

    local PVP_enabled = TheNet:GetPVPEnabled()

    return leader == target or
      (target_leader ~= nil and
        (target_leader == leader or (target_leader:HasTag("player") and not PVP_enabled))) or
      (target.components.domesticatable and target.components.domesticatable:IsDomesticated() and
        not PVP_enabled) or
      (target.components.saltlicker and target.components.saltlicker.salted and not PVP_enabled)
  elseif target_leader ~= nil and target_leader.components.inventoryitem then
    target_leader = target_leader.components.inventoryitem:GetGrandOwner()
    return target_leader ~= nil and target_leader:HasTag("senhai_holder")
  end

  return false
end

local function SpawnHealFx(inst, fx_prefab, scale)
  local x, y, z = inst.Transform:GetWorldPosition()
  local fx = SpawnPrefab(fx_prefab)
  fx.Transform:SetNoFaced()
  fx.Transform:SetPosition(x, y, z)

  scale = scale or 1
  fx.Transform:SetScale(scale, scale, scale)
end

local function GetOtherSpiders(inst, radius, tags)
  local x, y, z = inst.Transform:GetWorldPosition()

  local spiders =
    TheSim:FindEntities(x, y, z, radius, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO"}, tags) -- must tags, cant tags, must one of tags

  local valid_spiders = {}

  for _, spider in ipairs(spiders) do
    if
      spider:IsValid() and not spider.components.health:IsDead() and
        not spider:HasTag("playerghost")
     then
      table.insert(valid_spiders, spider)
    end
  end

  return valid_spiders
end

return {
  isLocalKeyEventReady = function(inst)
    if ThePlayer == nil then
      return false
    end

    local ActiveScreen = TheFrontEnd:GetActiveScreen()
    local Name = ActiveScreen and ActiveScreen.name or ""

    if Name:find("HUD") == nil then
      return false
    end

    if inst.replica.inventoryitem == nil then
      return false
    end

    if inst.replica.equippable == nil then
      return false
    end

    if not inst.replica.inventoryitem:IsGrandOwner(ThePlayer) then
      return false
    end

    if not inst.replica.equippable:IsEquipped() then
      return false
    end

    return true
  end,
  ResetLight = function(inst, i, f, r)
    inst.Light:SetIntensity(i)
    inst.Light:SetColour(215 / 255, 205 / 255, 255 / 255)
    inst.Light:SetFalloff(f)
    inst.Light:SetRadius(r)
    inst.Light:Enable(true)
  end,
  gainExp = function(player, amount, target, epic_mult)
    epic_mult = epic_mult or 3

    if player.components.achievementmanager and player.components.achievementmanager.sumexp then
      local old_say = player.components.talker.Say
      player.components.talker.Say = function()
      end

      player.components.achievementmanager:sumexp(
        player,
        ((target ~= nil and target:IsValid() and target:HasTag("epic")) and 3 or 1) * amount
      )

      player.components.talker.Say = old_say
    end
  end,
  slowDownTarget = function(player, target, slow_mult, duration)
    if
      player and target and player:IsValid() and target:IsValid() and player.components.health and
        not player.components.health:IsDead() and
        player.components.combat:IsValidTarget(target) and
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
  end,
  summonRetargetFn = function(inst)
    local function IsValidTarget(guy)
      return guy.components.health and not guy.components.health:IsDead() and
        inst.components.combat:CanTarget(guy) and
        -- not guy:HasTag("senhai_summons") and
        not (inst.components.follower ~= nil and inst.components.follower.leader == guy) and
        not HasFriendlyLeader(inst, guy) and
        not (inst.components.follower ~= nil and inst.components.follower.leader ~= nil and
          inst.components.follower.leader:HasTag("player") and
          guy:HasTag("player") and
          not TheNet:GetPVPEnabled()) and
        not (inst.components.follower ~= nil and inst.components.follower.leader ~= nil and
          inst.components.follower.leader.components.leader:IsFollower(guy))
    end

    return FindEntity(
      inst,
      SpringCombatMod(TUNING.TALLBIRD_TARGET_DIST),
      IsValidTarget,
      {"_combat", "_health", "character"},
      {"INLIMBO"}
    )
  end,
  MakeHealerSpiderDoHeal = function(inst)
    return function(spider_inst)
      local scale = 1.35

      SpawnHealFx(spider_inst, "spider_heal_ground_fx", scale)
      SpawnHealFx(spider_inst, "spider_heal_fx", scale)

      local other_spiders =
        GetOtherSpiders(
        spider_inst,
        TUNING.SPIDER_HEALING_RADIUS,
        {"senhai_holder", "senhai_summons", "_combat", "_health"}
      )

      local leader = spider_inst.components.follower.leader

      for _, spider in ipairs(other_spiders) do
        local target = spider.components.combat.target

        -- Don't heal the spider if it's targetting us / our leader / our leader's other followers
        local targetting_us =
          target ~= nil and
          (target == spider_inst or
            (leader ~= nil and (target == leader or leader.components.leader:IsFollower(target))))

        -- Don't heal the spider if it's leader is targetting us / our leader / our leader's other followers
        local spider_leader =
          spider.components.follower and spider.components.follower.leader or nil
        local their_targetting_us =
          (spider_leader ~= nil and
          (spider_leader.components.combat.target == spider_inst or
            (leader ~= nil and
              (spider_leader.components.combat.target == leader or
                leader.components.leader:IsFollower(spider_leader.components.combat.target)))))
        -- Don't heal the spider if it's leader's other followers are targetting us / our leader / our leader's other followers
        if spider_leader and spider_leader.components.leader then
          for spider_leader_follower, v in pairs(spider_leader.components.leader.followers) do
            if
              spider_leader_follower:IsValid() and spider_leader_follower.components.combat and
                spider_leader_follower.components.health and
                not spider_leader_follower.components.health:IsDead() and
                spider_leader_follower.components.follower ~= nil
             then
              their_targetting_us =
                their_targetting_us and
                spider_leader_follower.components.combat.target == spider_inst or
                (leader ~= nil and
                  (spider_leader_follower.components.combat.target == leader or
                    leader.components.leader:IsFollower(
                      spider_leader_follower.components.combat.target
                    )))
            end
          end
        end

        -- Don't heal the spider if we're targetting it / our leader is targetting it / our leader's other followers is targetting it
        local targetted_by_us =
          spider_inst.components.combat.target == spider or
          (leader ~= nil and
            (leader.components.combat:TargetIs(spider) or
              leader.components.leader:IsTargetedByFollowers(spider)))

        if not (targetting_us or targetted_by_us or their_targetting_us) then
          spider.components.health:DoDelta(
            spider:HasTag("senhai_holder") and inst.summon_spider_healer_heal_player_amount or
              inst.summon_spider_healer_heal_friends_amount,
            false,
            spider_inst.prefab
          )
          spider.components.combat.externaldamagemultipliers:SetModifier(
            inst,
            1.15,
            "senhai_spider_healer_buff"
          )
          inst:DoTaskInTime(
            2,
            function()
              spider.components.combat.externaldamagemultipliers:RemoveModifier(
                inst,
                "senhai_spider_healer_buff"
              )
            end
          )

          SpawnHealFx(spider, "spider_heal_target_fx")
        end
      end

      spider_inst.healtime = GetTime()
    end
  end,
  DoSpikeAttack = function(attacker, center, amount, damage, latency, dithering, attack_radius)
    local x, y, z = center.Transform:GetWorldPosition()
    local inital_r = dithering or 2

    x = GetRandomWithVariance(x, inital_r)
    z = GetRandomWithVariance(z, inital_r)

    local variations = {}

    for i = 1, amount do
      table.insert(variations, i)
    end

    shuffleArray(variations)

    local dtheta = PI * 2 / amount

    for i = 1, amount do
      local radius = dithering / 2 * 1.1 + math.random() * 1.75
      local theta = i * dtheta + math.random() * dtheta * 0.8 + dtheta * 0.2
      local x1 = x + radius * math.cos(theta)
      local z1 = z + radius * math.sin(theta)
      if
        TheWorld.Map:IsVisualGroundAtPoint(x1, 0, z1) and
          not TheWorld.Map:IsPointNearHole(Vector3(x1, 0, z1))
       then
        local spike = SpawnPrefab("moonspider_spike_senhai")
        spike.attack_radius = attack_radius
        spike.components.combat:SetDefaultDamage(damage)
        spike.Transform:SetPosition(x1, 0, z1)
        spike:SetOwner(attacker) -- inst.spider = attacker
        spike.latency = latency

        if variations[i + 1] ~= nil and variations[i + 1] ~= 1 and variations[i + 1] <= 5 then
          spike.AnimState:OverrideSymbol(
            "spike01",
            "spider_spike",
            "spike0" .. tostring(variations[i + 1])
          )
        end
      end
    end
  end
}
