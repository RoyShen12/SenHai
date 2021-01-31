local assets = {
  Asset("ANIM", "anim/senhai.zip"), --地上的动画
  Asset("ANIM", "anim/swap_senhai.zip"),
  Asset("ATLAS", "images/inventoryimages/senhai.xml"), --加载物品栏贴图
}

local function OnDropped(inst)
  inst.Light:Enable(true)
end

local function OnPutInInventory(inst)
  inst.Light:Enable(true)
end

local function onequip(inst, owner) --装备
  owner.AnimState:OverrideSymbol("swap_object", "swap_senhai", "swap_senhai")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) --解除装备
  owner.AnimState:Hide("ARM_carry")
  owner.AnimState:Show("ARM_normal")
end

local function calcHealthDrain(inst, owner, target)
  return (
    inst.components.weapon.damage +
    owner.components.combat.defaultdamage +
    target.components.combat.defaultdamage * 0.1
  ) *
  0.02 *
  (target:HasTag("epic") and 1.5 or 1) *
  (owner.components.health:GetPercent() < 0.2 and 2 or 1)
end

local function onattack(inst, owner, target)
  --加入冰杖效果
  inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/obsidian_wetsizzles")

  if not target:IsValid() then
    return
  end

  -- 熄火
  if target.components.burnable then
    if target.components.burnable:IsBurning() then
      target.components.burnable:Extinguish()
    elseif target.components.burnable:IsSmoldering() then
      target.components.burnable:SmotherSmolder()
    end
  end

  -- 吸血
  owner.components.health:DoDelta(calcHealthDrain(inst, owner, target))

  -- 几率 AOE
  if math.random(0, 100) > (100 - TUNING.SenHai.storm_chance) and
    owner.components.combat:IsValidTarget(target)
  then
    owner.components.talker:Say("风暴！")

    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.SenHai.storm_range)
      for k, v in pairs(ents) do
        if owner.components.combat:IsValidTarget(v) and
          v ~= target and
          v.components.combat and
          string.find(v.prefab, "wall") == nil
        then
          v.components.combat:GetAttacked(
            owner,
            owner.components.combat:CalcDamage(v, inst, TUNING.SenHai.storm_damage_ratio),
            inst
          )
          owner.components.health:DoDelta(
            calcHealthDrain(inst, owner, v) * TUNING.SenHai.storm_damage_ratio * 0.5
          )
        end
      end
  end
end

local function fn()
  local inst = CreateEntity()

  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  -- inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("senhai") --地上动画
  inst.AnimState:SetBuild("senhai")
  inst.AnimState:PlayAnimation("idle")

  -- inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
  -- inst:AddTag("pointy")

  inst:AddTag("irreplaceable")

  inst:AddTag("icestaff")
  inst:AddTag("extinguisher")

  -- inst.entity:SetPristine()

  -- if not TheWorld.ismastersim then
  --   return inst
  -- end

  inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
  inst.components.weapon:SetDamage(TUNING.SenHai.damage) --设置伤害34

  inst.components.weapon:SetRange(TUNING.SenHai.range, TUNING.SenHai.range + 2)
  inst.components.weapon:SetProjectile("ice_projectile")

  inst.components.weapon:SetOnAttack(onattack)
  -- inst.components.weapon.onattack = onattack

  inst:AddComponent("tool")
  inst.components.tool:SetAction(ACTIONS.CHOP, 4)
  inst.components.tool:SetAction(ACTIONS.MINE, 2)
  inst.components.tool:SetAction(ACTIONS.HACK, 2)

  -------
  inst:AddComponent("inspectable") --可检查组件

  inst:AddComponent("inventoryitem") --物品组件
  inst.components.inventoryitem.atlasname = "images/inventoryimages/senhai.xml" --物品贴图

  local light = inst.entity:AddLight()
  light:SetFalloff(0.88)
  light:SetIntensity(.2)
  light:SetRadius(2)
  light:SetColour(215 / 255, 205 / 255, 255 / 255)
  light:Enable(true)
  inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

  inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
  inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

  inst:AddComponent("equippable") --可装备组件
  inst.components.equippable:SetOnEquip(onequip)
  inst.components.equippable:SetOnUnequip(onunequip)
  inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT * 1.15
  inst.components.equippable.dapperness = TUNING.CRAZINESS_MED / 4

  -- MakeHauntableLaunch(inst)

  return inst
end
return Prefab("senhai", fn, assets, {})
