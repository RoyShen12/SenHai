return {
  gainExp = function(amount, target, epic_mult)
    epic_mult = epic_mult or 3

    if attacker.components.achievementmanager and attacker.components.achievementmanager.sumexp then
      local old_say = attacker.components.talker.Say
      attacker.components.talker.Say = function()
      end

      attacker.components.achievementmanager:sumexp(
        attacker,
        ((target ~= nil and target:IsValid() and target:HasTag("epic")) and 3 or 1) * amount
      )

      attacker.components.talker.Say = old_say
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
  end
}
