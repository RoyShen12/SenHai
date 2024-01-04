name = "猪猪杖"
description = [[
感谢产品经理: 森域
简介：
- 在战斗栏制造
- 可使用各种材料右键对武器使用来强化
- 强化材料越稀有，强化经验越高
- 自动拾取，拾取的范围随武器强化等级而提高
- 20级后升级为自动采摘
- 攻击带吸血效果
- 攻击有几率造成多种 AOE 效果
- 周期性使用饥饿值来治疗自己
- 攻击时有几率消耗精神和饥饿来对队友释放强力 HOT 治疗
- 攻击会减速敌人
- 可作为斧头、稿子和桨使用
- 时刻发光，光照范围随武器强化等级提高，放置在身上或丢下仍可发光
- 按O键开启/关闭锤子和铲子功能
- 按End键传送到另一个携带本物品的玩家身边
注：Mod 还做了这些改动
- 坎普斯背包变大
- 提高了天气棒、懒人魔杖、唤星杖的耐久
- 提高了老奶奶的精神上限
- 提升了大理石甲、铥甲、铥头盔的强度
- 提高了海星陷阱的强度并降低了充能间隔
附：部分武器基础强化经验值参考：
大部分的常规物品、食物和材料：0.1~6
宝石：6~8
触手棒：8
有名字的种子、挖下的植物、各种吹箭：10
魔法护符和法杖：10~30
各种帽子和盔甲：10
猪王的各种玩具：10
各种墙：15
书：20
化石碎片：35
月石：40
海钓鱼：120
月亮玻璃、铥：100
充能玻璃石、月亮碎片、月熠：140~160
蜘蛛帽、蜜蜂帽：180
蜂王浆、鹅毛、铥武器头盔护甲：200
熊毛：500
曼德拉草和烹饪物：510~550
黄油：600
巨鹿眼球：1000
眼球炮塔：1800
龙鳞：2500
蘑菇皮：3500
邪天翁材料：5000
犀牛角：10000
彩虹宝石：30000
启迪之冠：150000
强化时获得的强化经验是基础值乘上随机倍率 (1.0 ~ 5.0)
项目地址: https://github.com/RoyShen12/SenHai
]]
author = "Roy Shen"
version = "2.0.8"
forumthread = ""
dst_compatible = true              --兼容联机
dont_starve_compatible = false     --不兼容单机
reign_of_giants_compatible = false --不兼容巨人
shipwrecked_compatible = false     --不兼容海难

client_only_mod = false
all_clients_require_mod = true --所有人mod

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {}

local yes = "✓"
local no = "×"

configuration_options = {
  {
    name = "enableKrampusSack",
    label = "坎普斯背包变大",
    options = {
      { description = yes, data = true },
      { description = no,  data = false },
    },
    default = true,
  },
  -- { name = "Title", label = "", options = { { description = "", data = "" } }, default = "" },
  -- {
  --   name = "Title",
  --   label = "拾取",
  --   options = { { description = "", data = "" } },
  --   default = "",
  -- },
  {
    name = "mode",
    label = "数值难度",
    options = {
      { description = "无敌 数值+99%", data = 0.99 },
      { description = "无敌 数值+75%", data = 0.75 },
      { description = "简单 数值+50%", data = 0.5 },
      { description = "比较简单 数值+20%", data = 0.2 },
      { description = "有点简单 数值+10%", data = 0.1 },
      { description = "标准", data = 0 },
      { description = "微困难 数值-10%", data = -0.1 },
      { description = "有点困难 数值-20%", data = -0.2 },
      { description = "比较困难 数值-35%", data = -0.35 },
      { description = "困难 数值-40%", data = -0.4 },
    },
    default = 0,
  },
}
