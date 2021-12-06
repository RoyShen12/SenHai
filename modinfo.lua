name = "猪刀森海"
description = [[
森域 X 海域
]]
author = "猪猪"
version = "1.26"
forumthread = ""
dst_compatible = true --兼容联机
dont_starve_compatible = false --不兼容单机
reign_of_giants_compatible = false --不兼容巨人
shipwrecked_compatible = false

client_only_mod = false
all_clients_require_mod = true --所有人mod

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {}

configuration_options = {
  {
    name = "Damage",
    label = "武器基础伤害",
    options = {
      {description = "11", data = 11},
      {description = "15", data = 15},
      {description = "20", data = 20},
      {description = "25", data = 25},
      {description = "28", data = 28},
      {description = "32", data = 32},
      {description = "42", data = 42},
      {description = "52", data = 52},
      {description = "62", data = 62},
      {description = "72", data = 72},
      {description = "82", data = 82},
      {description = "102", data = 102},
      {description = "222", data = 222},
      {description = "552", data = 552},
      {description = "1002", data = 1002}
    },
    default = 32
  },
  {
    name = "Range",
    label = "基础射程",
    options = {
      {description = "0.75", data = 0.75},
      {description = "1.25", data = 1.25},
      {description = "1.75", data = 1.75},
      {description = "2", data = 2},
      {description = "4", data = 4},
      {description = "6", data = 6},
      {description = "8", data = 8},
      {description = "10", data = 10},
      {description = "12", data = 12},
      {description = "14", data = 14},
      {description = "16", data = 16}
    },
    default = 6
  },
  {
    name = "StormChance",
    label = "触发风暴几率",
    hover = "对目标周围的敌人造成群体 AOE",
    options = {
      {description = "0%", data = 0},
      {description = "2%", data = 2},
      {description = "5%", data = 5},
      {description = "10%", data = 10},
      {description = "15%", data = 15},
      {description = "20%", data = 20},
      {description = "30%", data = 30},
      {description = "60%", data = 60},
      {description = "100%", data = 100}
    },
    default = 10
  },
  {
    name = "StormRange",
    label = "风暴的范围",
    options = {
      {description = "1.5", data = 1.5},
      {description = "2", data = 2},
      {description = "2.5", data = 2.5},
      {description = "3", data = 3},
      {description = "3.5", data = 3.5},
      {description = "4", data = 4},
      {description = "6", data = 6},
      {description = "8", data = 8}
    },
    default = 4
  },
  {
    name = "StormDamageRatio",
    label = "风暴 AOE 伤害倍率",
    hover = "风暴伤害相对于主目标的比例",
    options = {
      {description = "10%", data = 0.1},
      {description = "20%", data = 0.2},
      {description = "30%", data = 0.3},
      {description = "40%", data = 0.4},
      {description = "50%", data = 0.5},
      {description = "60%", data = 0.6},
      {description = "70%", data = 0.7},
      {description = "80%", data = 0.8},
      {description = "90%", data = 0.9},
      {description = "100%", data = 1},
      {description = "110%", data = 1.1},
      {description = "120%", data = 1.2},
      {description = "130%", data = 1.3}
    },
    default = 0.3
  }
}
