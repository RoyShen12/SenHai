local assets = {
  Asset("ANIM", "anim/spider_spike.zip")
}

local prefabs = {
  "erode_ash"
}

local function KeepTargetFn()
  return false
end

local function shouldhit(inst, target)
  -- not casting spider
  if inst.spider == target then
    return false
  end

  -- other player's and their followers
  if
      not TheNet:GetPVPEnabled() and
      (target:HasTag("player") or
        (target.components.follower ~= nil and target.components.follower.leader ~= nil and
          target.components.follower.leader:HasTag("player")))
  then
    return false
  end

  return true
end

local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = {
  "flying",
  "shadow",
  "ghost",
  "FX",
  "NOCLICK",
  "DECOR",
  "INLIMBO",
  "playerghost"
}

local function DoAttack(inst)
  local attacker = (inst.spider ~= nil and inst.spider:IsValid()) and inst.spider or inst
  -- local old_damage = attacker.components.combat.defaultdamage
  local spike_damage = inst.components.combat.defaultdamage

  -- attacker.components.combat.ignorehitrange = true
  -- attacker.components.combat:SetDefaultDamage(spike_damage)

  local x, y, z = inst.Transform:GetWorldPosition()
  for _, v in ipairs(
    TheSim:FindEntities(x, y, z, inst.attack_radius + 3, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS)
  ) do
    if
        v:IsValid() and not v:IsInLimbo() and v.components.combat and
        not (v.components.health ~= nil and v.components.health:IsDead()) and
        (v:HasTag("monster") or v.components.combat.target == attacker) and
        not v:HasTag("wall") and
        string.find(v.prefab, "wall") == nil and
        string.find(v.prefab, "fence") == nil and
        shouldhit(inst, v)
    then
      local range = inst.attack_radius + v:GetPhysicsRadius(.5)
      if v:GetDistanceSqToPoint(x, y, z) < range * range and inst.components.combat:CanTarget(v) then
        -- attacker.components.combat:DoAttack(v)
        v.components.combat:GetAttacked(attacker, spike_damage, inst)
        -- gain exp (1/4)
        pcall(
          function()
            require("common-helper").gainExp(
              attacker,
              attacker.components.combat:GetWeapon().exp_from_hit * 0.25,
              v
            )
          end
        )
      end
    end
  end

  -- attacker.components.combat.ignorehitrange = false
  -- attacker.components.combat:SetDefaultDamage(old_damage)
end

local function KillSpike(inst)
  if not inst.killed then
    if inst.attack_task ~= nil then
      inst.attack_task:Cancel()
      inst.attack_task = nil
      inst:Remove()
    else
      inst.killed = true

      if inst.lifespan_task ~= nil then
        inst.lifespan_task:Cancel()
        inst.lifespan_task = nil
      end

      inst.AnimState:PlayAnimation("spike_pst")

      DoAttack(inst)

      inst.SoundEmitter:PlaySound("turnoftides/creatures/together/spider_moon/break")
      inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, inst.Remove)
    end
  end
end

local function StartAttack(inst)
  inst.attack_task = nil

  inst.AnimState:PlayAnimation("spike_pre")
  inst.SoundEmitter:PlaySoundWithParams(
    "turnoftides/creatures/together/spider_moon/spike",
    { intensity = math.random() }
  )
  inst.AnimState:PushAnimation("spike_loop")

  inst.lifespan_task =
      inst:DoTaskInTime((inst.latency or 2) * math.random(400, 600) / 1000, KillSpike)

  DoAttack(inst)
end

local function SetOwner(inst, spider)
  inst.spider = spider
end

local function fn()
  local inst = CreateEntity()

  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  inst.AnimState:SetBank("spider_spike")
  inst.AnimState:SetBuild("spider_spike")
  inst.AnimState:PlayAnimation("empty")
  inst.AnimState:SetFinalOffset(1)

  inst:AddTag("NOCLICK")
  inst:AddTag("notarget")
  inst:AddTag("groundspike")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("combat")
  inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

  inst.persists = false

  inst.KillSpike = function()
    KillSpike(inst)
  end

  inst.attack_task = inst:DoTaskInTime(math.random() * 0.25, StartAttack)

  inst.SetOwner = SetOwner

  return inst
end

return Prefab("moonspider_spike_senhai", fn, assets, prefabs)
