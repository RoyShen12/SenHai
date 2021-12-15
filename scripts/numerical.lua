local Numerical = {
  GetPropertyWithLevel = function(level)
    return {
      pick_up_range = math.min(15, 2 + level * 0.3),
      storm_chance = math.min(90, 10 + level * 1.33), -- 0~100
      storm_range = 2 + math.min(12, level * 0.25),
      storm_damage_ratio = math.min(2.0, 0.1 + level * 0.025), -- 0.0~1.0
      spike_chance = math.min(90, 5 + level * 1.31), -- 0~100
      spike_amount_upper = math.floor(2 + math.floor(level * 0.375 + 0.5)),
      spike_amount_lower = math.floor(1 + math.floor(level * 0.105 + 0.5)),
      spike_damage = 10 + level * 1.25,
      spike_latency = math.max(0.2, 2 - level * 0.0375),
      spike_radius = math.min(4, 1 + level * 0.045),
      summon_cd = math.max(4, 45 - math.floor(level * 0.88 + 0.5)),
      summon_amount = math.min(5, 1 + math.floor(level * 0.06666667)),
      summon_health_addition = level * 12,
      summon_health_regen = math.floor(1 + level * 0.205 + 0.5),
      summon_damage_addition = math.floor(level * 1.775 + 0.5),
      summon_attack_period_mutl = math.max(0.15, 1 - level * 0.02),
      summon_speed_addition = math.min(15, 5 + level * 0.22),
      summon_extra_armor = math.min(0.75, level * 0.006667),
      peridic_heal_cd = math.max(1, 15 - level * 0.4),
      peridic_heal_amount = 1 + math.floor(level * 0.2),
      heal_hunger_rate = math.max(1.05, 1.6 - level * 0.01),
      shadow_healing_chance = math.min(50, 5 + level * 0.65), -- 0~100
      shadow_healing_amount = math.min(10, 1 + level * 0.15),
      shadow_healing_cost = math.max(5, 15 - level * 0.12),
      health_steel_ratio = math.min(0.75, (0.5 + 0.1 * (level + 1)) * 0.016),
      slowing_rate = math.min(0.990, 0.1 + (level + 5) * 0.01),
      slowing_duration = math.min(6, 0.75 + level * 0.1),
      exp_from_hit = 5 + level * 3,
      boost_speed_amount = math.min(4, 0.5 + level * 0.175),
      chop_power = math.min(20, 1 + level * 0.5),
      mine_power = math.min(20, 1 + level * 0.5),
      oar_power = math.min(0.98, 0.2 + level * 0.02),
      oar_max_velocity = math.min(15, 2 + level * 0.4),
      damage = 12 + level * 3,
      range_base = 1.5 + math.min(10, level * 0.2),
      range_escape = 2.5 + math.min(12, 0.5 * level),
      walkspeedmult = math.min(
        2.55,
        math.floor(TUNING.CANE_SPEED_MULT * (100 + level * 1.75)) / 100
      ),
      dapperness = TUNING.DAPPERNESS_MED * math.min(3, 0.5 + level * 0.06),
      light_radius = math.min(32, 2 + level * 1.5),
      light_falloff = math.max(0.8, 1.2 - level * 0.01),
      light_intensity = math.min(0.97, 0.92 + level * 0.00125)
    }
  end
}

return Numerical
