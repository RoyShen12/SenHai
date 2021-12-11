local Constants = {
  WeaponExpTable = {
    wetgoop = 1,
    spoiled_food = 1,
    spear = 1,
    torch = 1,
    heatrock = 1,
    bedroll_straw = 1,
    spear_wathgrithr = 1,
    wathgrithrhat = 1,
    sewing_tape = 1,
    saltrock = 1,
    driftwood_log = 1,
    spoiled_fish = 1,
    spoiled_fish_small = 1,
    rottenegg = 1,
    ash = 1,
    feather_crow = 1,
    feather_robin = 1,
    feather_robin_winter = 1,
    silk = 1,
    cutgrass = 1,
    flint = 1,
    rocks = 1,
    nitre = 1,
    log = 1,
    twigs = 1,
    monstermeat = 1,
    poop = 1,
    guano = 1,
    boneshard = 1,
    houndstooth = 1,
    beardhair = 1,
    fishmeat_small = 1,
    smallmeat = 1,
    cutlichen = 1,
    cave_banana = 1,
    acorn = 1,
    pinecone = 1,
    twiggy_nut = 1,
    butterflywings = 1,
    hambat = 2,
    petals = 2,
    marble = 2,
    charcoal = 2,
    meat = 2,
    drumstick = 2,
    froglegs = 2,
    bird_egg = 2,
    fishmeat = 2,
    pigskin = 2,
    manrabbit_tail = 2,
    batwing = 2,
    spidergland = 2,
    furtuft = 2,
    mosquitosack = 2,
    sketch = 3,
    tacklesketch = 3,
    blueprint = 3,
    nightstick = 3,
    lightbulb = 3,
    wormlight = 3,
    wormlight_lesser = 3,
    honeycomb = 3,
    stinger = 3,
    cutreeds = 3,
    coontail = 3,
    gears = 3,
    thulecite_pieces = 3,
    glommerwings = 3,
    glommerfuel = 3,
    glommerflower = 3,
    ice = 3,
    tallbirdegg = 3,
    plantmeat = 3,
    gunpowder = 3,
    goldnugget = 3,
    beefalowool = 3,
    seeds = 3,
    boards = 4,
    cutstone = 4,
    whip = 4,
    nightmarefuel = 4,
    petals_evil = 4,
    cactus_flower = 5,
    livinglog = 5,
    phlegm = 5,
    spidereggsack = 5,
    steelwool = 5,
    trunk_summer = 5,
    trunk_winter = 5,
    trunk_cooked = 5,
    walrus_tusk = 5,
    feather_canary = 5,
    tentaclespots = 5,
    horn = 5,
    lightninggoathorn = 5,
    cookiecuttershell = 5,
    slurper_pelt = 5,
    cane = 5,
    fig = 5,
    transistor = 5,
    boomerang = 5,
    spore_small = 5,
    spore_medium = 5,
    spore_tall = 5,
    papyrus = 6,
    waxpaper = 6,
    beeswax = 6,
    slurtleslime = 6,
    redgem = 6,
    bluegem = 6,
    purplegem = 7,
    greengem = 7,
    orangegem = 8,
    yellowgem = 8,
    tentaclespike = 8,
    corn_seeds = 10,
    carrot_seeds = 10,
    eggplant_seeds = 10,
    pumpkin_seeds = 10,
    pomegranate_seeds = 10,
    durian_seeds = 10,
    dragonfruit_seeds = 10,
    watermelon_seeds = 10,
    amulet = 10,
    blowdart_pipe = 10,
    blowdart_sleep = 10,
    blowdart_fire = 10,
    dug_grass = 10,
    dug_sapling = 10,
    dug_berrybush = 10,
    dug_berrybush2 = 10,
    dug_berrybush_juicy = 10,
    dug_marsh_bush = 10,
    dug_rock_avocado_bush = 10,
    orangeamulet = 12,
    yellowamulet = 12,
    greenamulet = 12,
    blueamulet = 12,
    purpleamulet = 12,
    blowdart_yellow = 15,
    icestaff = 15,
    firestaff = 15,
    telestaff = 20,
    orangestaff = 20,
    staff_tornado = 20,
    greenstaff = 20,
    yellowstaff = 25,
    opalstaff = 30,
    fossil_piece = 35,
    fossil_piece_clean = 35,
    moonrocknugget = 40,
    moonglass = 100,
    thulecite = 100,
    moonglass_charged = 140,
    moonstorm_spark = 150,
    moonstorm_glass = 160,
    spiderhat = 180,
    hivehat = 180,
    royal_jelly = 200,
    goose_feather = 200,
    ruins_bat = 200,
    ruinshat = 200,
    armorruins = 200,
    bearger_fur = 500,
    mandrake = 500,
    cookedmandrake = 510,
    mandrakesoup = 550,
    butter = 600,
    deerclops_eyeball = 1000,
    eyeturret_item = 1800,
    expbean = 2000,
    dragon_scales = 2500,
    shroom_skin = 3500,
    malbatross_beak = 5000,
    malbatross_feather = 5000,
    minotaurhorn = 10000,
    opalpreciousgem = 30000,
    alterguardianhat = 150000
  },
  PickUpForbidPrefabs = {
    spear = true,
    spear_wathgrithr = true,
    torch = true,
    axe = true,
    goldenaxe = true,
    pickaxe = true,
    goldenpickaxe = true,
    shovel = true,
    goldenshovel = true,
    hammer = true,
    multitool_axe_pickaxe = true,
    pitchfork = true,
    razor = true,
    featherpencil = true,
    fishingrod = true,
    oceanfishingrod = true,
    panflute = true,
    lantern = true,
    pumpkin_lantern = true,
    brush = true,
    farm_hoe = true,
    golden_farm_hoe = true,
    wateringcan = true,
    premiumwateringcan = true,
    tillweedsalve = true,
    seedpouch = true,
    compostingbin = true,
    plantregistryhat = true,
    nutrientsgoggleshat = true,
    trophyscale_oversizedveggies = true,
    book_horticulture = true,
    book_silviculture = true,
    fruitfly = true,
    lordfruitfly = true,
    friendlyfruitfly = true,
    fruitflyfruit = true,
    farm_soil_debris = true,
    soil_amender = true,
    soil_amender_fermented = true,
    compost = true,
    compostwrap = true,
    fertilizer = true,
    bugnet = true,
    trap = true,
    birdtrap = true,
    chester_eyebone = true,
    glommerflower = true,
    lavae_egg = true,
    lavae_cocoon = true,
    glommerfuel = true,
    horn = true,
    heatrock = true,
    -- flint = true,
    bedroll_straw = true,
    bedroll_furry = true,
    featherfan = true,
    tentaclespike = true,
    batbat = true,
    nightsword = true,
    ruins_bat = true,
    -- spidereggsack = true,
    wetgoop = true,
    spoiled_food = true,
    sketch = true,
    amulet = true,
    glommerwings = true,
    bernie_inactive = true,
    lighter = true,
    abigail_flower = true,
    lucy = true,
    reskin_tool = true,
    terrarium = true,
    tacklesketch = true,
    raincoat = true,
    sweatervest = true,
    reflectivevest = true,
    hawaiianshirt = true,
    beargervest = true,
    cane = true,
    mandrake = true,
    cookedmandrake = true,
    mandrakesoup = true,
    cookbook = true,
    fishingnet = true,
    mast_item = true,
    mast_malbatross_item = true,
    malbatross_feathered_weave = true,
    oar = true,
    oar_driftwood = true,
    miniflare = true,
    saltbox = true,
    saddlehorn = true,
    saddle_basic = true,
    reviver = true,
    diviningrod = true,
    grass_umbrella = true,
    umbrella = true,
    waterballoon = true,
    compass = true,
    onemanband = true,
    mapscroll = true,
    waxwelljournal = true,
    book_gardening = true,
    book_birds = true,
    book_sleep = true,
    book_tentacles = true,
    book_brimstone = true,
    thurible = true,
    saddle_war = true,
    saddle_race = true,
    trap_teeth = true,
    beemine = true,
    boomerang = true,
    trap_teeth_maxwell = true,
    beemine_maxwell = true,
    rock_avocado_fruit = true,
    rock_avocado_fruit_sprout = true,
    moonrockseed = true,
    bullkelp_beachedroot = true,
    beef_bell = true,
    moonrockidol = true,
    blueprint = true,
    tacklecontainer = true,
    supertacklecontainer = true
  },
  PickUpForbidPattern = {
    "staff",
    "_tacklesketch",
    "_sketch",
    "deer_antler",
    "blowdart_",
    ".*hat$",
    "^armor.*",
    "trunkvest_",
    "oceanfishingbobber_",
    "_blueprint",
    "archive_lockbox"
  },
  SummonsList = {
    spider = 100,
    spider_hider = 20,
    spider_spitter = 50,
    spider_warrior = 30,
    spider_healer = 10,
    hound = 100,
    icehound = 20
    -- tallbird = 10
    -- spiderqueen = 120
  },
  SummonsNicknameList = {
    spider = "小叽居",
    spider_hider = "小龟缩叽居",
    spider_spitter = "小吐网叽居",
    spider_warrior = "小战斗叽居",
    spider_healer = "小奶妈叽居",
    hound = "小汪汪",
    icehound = "小冰汪汪"
    -- tallbird = "小鸟"
  }
}

local weight_total = 0
for _, value in pairs(Constants.SummonsList) do
  weight_total = weight_total + value
end
local acc = 0
for key, value in pairs(Constants.SummonsList) do
  local chance = value / weight_total
  Constants.SummonsList[key] = acc + chance
  acc = acc + chance
end

return Constants
