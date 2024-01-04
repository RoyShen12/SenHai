local Numerical = {
  GetPropertyWithLevel = function(level, modifier)
    local increase_modifier = 1 + modifier
    local reduction_modifier = 1 / increase_modifier

    return {
      pick_up_range = math.min(20, 3 + level * 0.425) * increase_modifier,
      storm_chance = math.min(75, 5 + level * 1) * increase_modifier,              -- 0~100
      storm_range = 2 + math.min(10, level * 0.16) * increase_modifier,
      storm_damage_ratio = math.min(1.0, 0.1 + level * 0.012) * increase_modifier, -- 0.0~1.0
      spike_chance = math.min(95, 10 + level * 1.3077) * increase_modifier,        -- 0~100
      spike_amount_upper = math.floor(2 + math.floor(level * 0.375 + 0.5)) * increase_modifier,
      spike_amount_lower = math.floor(1 + math.floor(level * 0.105 + 0.5)) * increase_modifier,
      spike_damage = 10 + math.floor(level * 1.222222 + 0.5) * increase_modifier,
      spike_latency = math.max(0.2, 2 - level * 0.0375) * reduction_modifier,
      spike_radius = math.min(4, 1 + level * 0.045) * increase_modifier,
      peridic_heal_cd = math.max(1, 15 - level * 0.4) * reduction_modifier,
      peridic_heal_amount = 1 + math.floor(level * 0.2) * increase_modifier,
      heal_hunger_rate = math.max(0.45, 1.1 - level * 0.01) * reduction_modifier,
      shadow_healing_chance = math.min(50, 5 + level * 0.65) * increase_modifier, -- 0~100
      shadow_healing_amount = math.min(10, 1 + level * 0.15) * increase_modifier,
      shadow_healing_cost = math.max(5, 15 - level * 0.12) * reduction_modifier,
      health_steel_ratio = math.min(0.75, (0.5 + 0.1 * (level + 1)) * 0.016) * increase_modifier,
      slowing_rate = math.min(0.990, 0.1 + (level + 5) * 0.01) * increase_modifier,
      slowing_duration = math.min(6, 0.75 + level * 0.1) * increase_modifier,
      exp_from_hit = (5 + level * 3) * increase_modifier,
      boost_speed_amount = math.min(2, 0.2 + level * 0.04) * increase_modifier,
      chop_power = math.min(20, 1 + level * 0.5) * increase_modifier,
      mine_power = math.min(20, 1 + level * 0.5) * increase_modifier,
      hammer_power = math.min(20, 1 + level * 0.5) * increase_modifier,
      dig_power = math.min(20, 1 + level * 0.5) * increase_modifier,
      oar_power = math.min(0.98, 0.2 + level * 0.02),
      oar_max_velocity = math.min(15, 2 + level * 0.4),
      damage = (12 + math.floor(level * 1.333333 + 0.5)) * increase_modifier,
      range_base = (1.5 + math.min(8.5, level * 0.2)) * (1 + modifier * 0.05),
      range_escape = (2 + math.min(9, level * 0.2)) * (1 + modifier * 0.05),
      walkspeedmult = (math.min(
        2.55,
        math.floor(TUNING.CANE_SPEED_MULT * (100 + level * 1.75)) / 100
      )) * (1 + modifier * 0.07),
      dapperness = TUNING.DAPPERNESS_MED * math.min(3, 0.5 + level * 0.06) * (1 + modifier * 0.03),
      light_radius = math.min(32, 2 + level * 1.5),
      light_falloff = math.max(0.8, 1.2 - level * 0.01),
      light_intensity = math.min(0.97, 0.92 + level * 0.00125)
    }
  end
}

return Numerical

-- summon_cd = math.max(15, 90 - math.floor(level * 0.88 + 0.5)),
-- summon_amount = math.min(5, 1 + math.floor(level * 0.06666667)),
-- summon_health_addition = level * 12,
-- summon_health_regen = math.floor(1 + level * 0.205 + 0.5),
-- summon_damage_addition = math.floor(level * 1.775 + 0.5),
-- summon_attack_period_mutl = math.max(0.15, 1 - level * 0.02),
-- summon_speed_addition = math.min(22, 5 + level * 0.38),
-- summon_extra_armor = math.min(0.75, level * 0.006667),                -- 0: no absord, 1: fully absorb
-- summon_extra_range = math.min(4, level * 0.06),
-- summon_spider_dropper_poison_chance = math.min(25, level * 0.42),     -- 0~100
-- summon_spider_dropper_poison_damage = math.min(12, 1 + level * 0.18), -- 0.1s * 10 drop
-- summon_spider_healer_heal_player_amount = math.min(300, 20 + math.floor(level * 4.3077 + 0.5)),
-- summon_spider_healer_heal_friends_amount = math.min(
--   1200,
--   80 + math.floor(level * 17.23077 + 0.5)
-- ),
