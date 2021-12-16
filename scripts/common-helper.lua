return {
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
  summonRetargetFn = function(_inst)
    local function HasFriendlyLeader(__inst, target)
      local leader = __inst.components.follower.leader

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
        return target_leader ~= nil and target_leader:HasTag("spiderwhisperer")
      end

      return false
    end

    local function IsValidTarget(guy)
      return guy.components.health and not guy.components.health:IsDead() and
        _inst.components.combat:CanTarget(guy) and
        not guy:HasTag("senhai_summons") and
        not (_inst.components.follower ~= nil and _inst.components.follower.leader == guy) and
        not HasFriendlyLeader(_inst, guy) and
        not (_inst.components.follower ~= nil and _inst.components.follower.leader ~= nil and
          _inst.components.follower.leader:HasTag("player") and
          guy:HasTag("player") and
          not TheNet:GetPVPEnabled())
    end

    return FindEntity(
      _inst,
      SpringCombatMod(TUNING.TALLBIRD_TARGET_DIST),
      IsValidTarget,
      {"_combat", "_health", "character"},
      {"INLIMBO"}
    )
  end
}
