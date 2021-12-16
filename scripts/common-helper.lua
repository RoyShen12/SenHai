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
  end
}
