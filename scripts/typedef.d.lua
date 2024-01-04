---@alias minSpacingSqFn fun(ent: Prefab): number
---@alias nearOtherFn fun(e: Prefab, pt: Point, min: number): boolean
---@alias ScreenRef { inst: PlayerPrefab }
---@alias ScreenOffset { ref: ScreenRef, xoffset: number }
---@alias ContainerWidget { slotpos: Vector3[], animbank: string, animbuild: string, pos: Vector3 }
---@alias StateGraph { tags: table<string, any>, HasStateTag: fun(self: StateGraph, tag: string): boolean }
---@alias Skill { name: string, cooldown: number }

---@class NetVal

---@class NetBool: NetVal
---@field value fun(self: NetVal): boolean

---@class NetNumber: NetVal
---@field value fun(self: NetVal): number

---@class NetNumberArray: NetVal
---@field value fun(self: NetVal): number[]

---@class NetHash: NetVal
---@field value fun(self: NetVal): string

---@class NetEvent: NetBool
---@field Push fun(self: NetEvent): nil

---@class NetEntity: NetVal
---@field value fun(self: NetVal): Prefab

---@class TheNet
---@field SendSlashCmdToServer fun(self: TheNet, command: string, force: boolean): nil
---@field GetServerName fun(self: TheNet): string
---@field Say fun(self: TheNet, words: string, wisper: boolean): nil
---@field SendModRPCToServer fun(self: TheNet, mod_name: string, action_code: integer, ...: any): nil

---@class EmberShop
---@field PriceList table<string, { prefab: string }[]>
---@field GetRealPrice fun(name: string, player: PlayerPrefab): number

---@class Task
---@field guid integer
---@field param any
---@field id string
---@field fn function
---@field co thread

---@class Periodic
---@field id string
---@field fn function
---@field period number
---@field limit integer
---@field nexttick number
---@field arg any
---@field Cancel fun(self: Periodic): nil
---@field Cleanup fun(self: Periodic): nil

---@class SchedulerHost
---@field KillTasks fun(self: SchedulerHost): nil
---@field StartThread fun(self: SchedulerHost, fn: function): Task
---@field DoPeriodicTask fun(self: SchedulerHost, time: number, fn: function, initialdelay: number, ...): Periodic
---@field DoTaskInTime fun(self: SchedulerHost, time: number, fn: function, ...): Periodic

---@class Point
---@field x number
---@field y number
---@field z number
---@field Get fun(self: Point): number, number, number
---@field __add fun(self: Point, rhs: Point): Point
---@field __sub fun(self: Point, rhs: Point): Point
---@field __mul fun(self: Point, rhs: Point): Point
---@field __div fun(self: Point, rhs: Point): Point
---@field __unm fun(self: Point): Point get point with -x, -y, -z
---@field Dot fun(self: Point, rhs: Point): number
---@field Cross fun(self: Point, rhs: Point): Point
---@field __eq fun(self: Point, rhs: Point): boolean
---@field DistSq fun(self: Point, other: Point): number
---@field Dist fun(self: Point, other: Point): number
---@field LengthSq fun(self: Point): number
---@field Length fun(self: Point): number
---@field Normalize fun(self: Point): Point self
---@field GetNormalized fun(self: Point): Point

---@alias Vector3 Point

---@class Ingredient
---@field type string
---@field amount integer

---@class Recipe
---@field name string
---@field ingredients Ingredient[]
---@field character_ingredients Ingredient[]
---@field tech_ingredients Ingredient[]
---@field product string
---@field description string
---@field rpc_id number
---@field min_spacing number
---@field testfn fun(self: Recipe, pt: Point, rot: number): boolean
---@field nounlock boolean
---@field numtogive number
---@field build_mode number
---@field build_distance number

---@class TheSim
---@field FindEntities fun(self: TheSim, x: number, y: number, z: number, radius: number, musttags: string[] | nil, canttags: string[] | nil, mustoneoftags: string[] | nil): Prefab[]
---@field SetDebugRenderEnabled fun(self: TheSim, force: boolean): nil
---@field GetPersistentString fun(self: TheSim, path_or_namespace: string, onload: fun(load_success: boolean, data: any): nil): string
---@field GetPosition fun(self: TheSim): number, number
---@field GetTickTime fun(self: TheSim): number
---@field GetTick fun(self: TheSim): number

---@class TheMap
---@field GetTileAtPoint fun(self: TheMap, x: number, y: number, z: number): number
---@field IsPassableAtPoint fun(self: TheMap, x: number, y: number, z: number, allow_water: boolean | nil, exclude_boats: boolean | nil): boolean
---@field IsPassableAtPointWithPlatformRadiusBias fun(self: TheMap, x: number, y: number, z: number, allow_water: boolean | nil, exclude_boats: boolean | nil, platform_radius_bias: number | nil, ignore_land_overhang: boolean | nil): boolean
---@field IsAboveGroundAtPoint fun(self: TheMap, x: number, y: number, z: number, allow_water: boolean | nil): boolean
---@field IsOceanTileAtPoint fun(self: TheMap, x: number, y: number, z: number): boolean
---@field IsOceanAtPoint fun(self: TheMap, x: number, y: number, z: number, allow_boats: boolean | nil): boolean
---@field IsValidTileAtPoint fun(self: TheMap, x: number, y: number, z: number): boolean
---@field CanTerraformAtPoint fun(self: TheMap, x: number, y: number, z: number): boolean
---@field CanPlowAtPoint fun(self: TheMap, x: number, y: number, z: number): boolean
---@field CanPlaceTurfAtPoint fun(self: TheMap, x: number, y: number, z: number): boolean
---@field CanPlantAtPoint fun(self: TheMap, x: number, y: number, z: number): boolean
---@field IsFarmableSoilAtPoint fun(self: TheMap, x: number, y: number, z: number): boolean
---@field CanTillSoilAtPoint fun(self: TheMap, x: number, y: number, z: number, ignore_tile_type: boolean | nil): boolean
---@field IsPointNearHole fun(self: TheMap, pt: Point, range: number | nil): boolean
---@field IsGroundTargetBlocked fun(self: TheMap, pt: Point, range: number | nil): boolean
---@field IsDeployPointClear fun(self: TheMap, pt: Point, inst: Prefab, min_spacing: number | nil, min_spacing_sq_fn: minSpacingSqFn | nil, near_other_fn: nearOtherFn | nil, check_player: boolean | nil, custom_ignore_tags: string[] | nil): boolean
---@field CanDeployAtPoint fun(self: TheMap, pt: Point, inst: Prefab, mouseover: Prefab | nil): boolean
---@field CanDeployPlantAtPoint fun(self: TheMap, pt: Point, inst: Prefab): boolean
---@field CanDeployWallAtPoint fun(self: TheMap, pt: Point, inst: Prefab): boolean
---@field CanDeployAtPointInWater fun(self: TheMap, pt: Point, inst: Prefab, mouseover: Prefab | nil, data: { boat: number | nil, land: number | nil, radius: number } | nil): boolean
---@field CanDeployMastAtPoint fun(self: TheMap, pt: Point, inst: Prefab, mouseover: Prefab | nil): boolean
---@field CanPlacePrefabFilteredAtPoint fun(self: TheMap, x: number, y: number, z: number, prefab: string | nil): boolean
---@field CanDeployRecipeAtPoint fun(self: TheMap, pt: Point, recipe: Recipe, rot: number): boolean
---@field IsSurroundedByWater fun(self: TheMap, x: number, y: number, z: number, radius: number | nil): boolean
---@field GetNearestPointOnWater fun(self: TheMap, x: number, z: number, radius: number, iterations: number): boolean, number, number
---@field InternalIsPointOnWater fun(self: TheMap, test_x: number, test_y: number, test_z: number): boolean
---@field GetPlatformAtPoint fun(self: TheMap, pos_x: number, pos_y: number, pos_z: number, extra_radius: number | nil): Prefab | nil
---@field FindRandomPointInOcean fun(self: TheMap, max_tries: number): Vector3
---@field IsInLunacyArea fun(self: TheMap, x: number, y: number, z: number): boolean

---@class FollowCamera
---@field inst PlayerPrefab
---@field target Prefab | nil
---@field currentpos Vector3
---@field targetoffset Vector3
---@field targetpos Vector3
---@field headingtarget number default 45
---@field fov number default 35
---@field pangain number
---@field headinggain number
---@field distancegain number
---@field zoomstep number
---@field distancetarget number
---@field mindist number
---@field maxdist number
---@field mindistpitch number
---@field maxdistpitch number
---@field paused boolean
---@field controllable boolean
---@field cutscene boolean
---@field currentscreenxoffset number
---@field distance number default 30
---@field screenoffsetstack ScreenOffset[]
---@field time_since_zoom number | nil
---@field SetDefaultOffset fun(self: FollowCamera): nil
---@field SetDefault fun(self: FollowCamera): nil
---@field GetRightVec fun(self: FollowCamera): Vector3
---@field GetDownVec fun(self: FollowCamera): Vector3
---@field GetPitchDownVec fun(self: FollowCamera): Vector3
---@field SetPaused fun(self: FollowCamera, val: boolean): nil
---@field SetMinDistance fun(self: FollowCamera, distance: number): nil
---@field SetMaxDistance fun(self: FollowCamera, distance: number): nil
---@field SetGains fun(self: FollowCamera, pan: number, heading: number, distance: number): nil
---@field GetGains fun(self: FollowCamera): number, number, number
---@field IsControllable fun(self: FollowCamera): boolean
---@field SetControllable fun(self: FollowCamera, val: boolean): nil
---@field CanControl fun(self: FollowCamera): boolean
---@field SetOffset fun(self: FollowCamera, offset: number): nil
---@field PushScreenHOffset fun(self: FollowCamera, ref: ScreenRef, xoffset: number): nil
---@field PopScreenHOffset fun(self: FollowCamera, ref: ScreenRef): nil
---@field GetDistance fun(self: FollowCamera): number
---@field SetDistance fun(self: FollowCamera, dist: number): nil
---@field Shake fun(self: FollowCamera, type: integer, duration: number, speed: number, scale: number): nil
---@field SetTarget fun(self: FollowCamera, inst: Prefab): nil
---@field Apply fun(self: FollowCamera): nil
---@field GetHeading fun(self: FollowCamera): number
---@field GetHeadingTarget fun(self: FollowCamera): number
---@field SetHeadingTarget fun(self: FollowCamera, r: number): nil
---@field ZoomIn fun(self: FollowCamera, step: number): nil
---@field ZoomOut fun(self: FollowCamera, step: number): nil
---@field Snap fun(self: FollowCamera): nil
---@field CutsceneMode fun(self: FollowCamera, b: boolean): nil
---@field SetCustomLocation fun(self: FollowCamera, loc: Point): nil
---@field Update fun(self: FollowCamera, dt: number, dontupdatepos: boolean | nil): nil
---@field UpdateListeners fun(self: FollowCamera, dt: number): nil
---@field SetOnUpdateFn fun(self: FollowCamera, fn: fun(self: FollowCamera, dt: number): nil): nil
---@field AddListener fun(self: FollowCamera, src: string, cb: fun(dt: number): nil): nil
---@field RemoveListener fun(self: FollowCamera, src: string, cb: fun(dt: number): nil): nil

---@class Input
---@field DisableAllControllers fun(self: Input): nil
---@field EnableAllControllers fun(self: Input): nil
---@field EnableMouse fun(self: Input, enable: boolean): nil
---@field ClearCachedController fun(self: Input): nil
---@field CacheController fun(self: Input): number
---@field TryRecacheController fun(self: Input): nil
---@field GetControllerID fun(self: Input): number
---@field ControllerAttached fun(self: Input): boolean
---@field ControllerConnected fun(self: Input): boolean
---@field GetInputDevices fun(self: Input): { text: string, data: integer }
---@field AddTextInputHandler fun(self: Input, fn: function): nil
---@field AddKeyUpHandler fun(self: Input, key: integer, fn: function): nil
---@field AddKeyDownHandler fun(self: Input, key: integer, fn: function): nil
---@field AddKeyHandler fun(self: Input, fn: function): nil
---@field AddMouseButtonHandler fun(self: Input, fn: function): nil
---@field AddMoveHandler fun(self: Input, fn: function): nil
---@field AddControlHandler fun(self: Input, control: any, fn: function): nil
---@field AddGeneralControlHandler fun(self: Input, fn: function): nil
---@field AddControlMappingHandler fun(self: Input, fn: function): nil
---@field AddGestureHandler fun(self: Input, gesture: any, fn: function): nil
---@field UpdatePosition fun(self: Input, x: number, y: number): nil
---@field OnControl fun(self: Input, control: any, digitalvalue: number, analogvalue: number): nil
---@field OnMouseMove fun(self: Input, x: number, y: number): nil
---@field OnMouseButton fun(self: Input, button: number, down: boolean, x: number, y: number): nil
---@field OnRawKey fun(self: Input, key: number, down: boolean): nil
---@field OnText fun(self: Input, text: string): nil
---@field OnGesture fun(self: Input, gesture: any): nil
---@field OnControlMapped fun(self: Input, deviceId: integer, controlId: integer, inputId: integer, hasChanged: boolean): nil
---@field OnFrameStart fun(self: Input): nil
---@field GetScreenPosition fun(self: Input): Vector3
---@field GetWorldPosition fun(self: Input): Vector3
---@field GetAllEntitiesUnderMouse fun(self: Input): Prefab[]
---@field GetWorldEntityUnderMouse fun(self: Input): Prefab
---@field GetHUDEntityUnderMouse fun(self: Input): Prefab
---@field IsMouseDown fun(self: Input, button: number): boolean
---@field IsKeyDown fun(self: Input, key: integer): boolean
---@field IsControlPressed fun(self: Input, control: any): boolean
---@field GetAnalogControlValue fun(self: Input, control: any): any
---@field IsPasteKey fun(self: Input, key: integer): boolean
---@field UpdateEntitiesUnderMouse fun(self: Input): nil
---@field OnUpdate fun(self: Input): nil
---@field GetControlIsMouseWheel fun(self: Input, controlId: number): boolean
---@field PlatformUsesVirtualKeyboard fun(self: Input): boolean

---@class TheWorld: SchedulerHost
---@field worldname string
---@field Map TheMap
---@field state { isspring: boolean, issummer: boolean, isautumn: boolean, iswinter: boolean, isnight: boolean, seasonprogress: number, phase: number, israining: boolean,issnowing: boolean }

---@class Action
---@field priority number
---@field code number
---@field canforce boolean
---@field mod_name string | nil
---@field pre_action_cb function

---@class BufferedAction
---@field doer Prefab
---@field target Prefab
---@field action Action
---@field forced boolean
---@field pos Point | nil
---@field rotation number
---@field recipe Recipe | nil
---@field distance number
---@field autoequipped boolean | nil
---@field skin string | nil
---@field Do fun(self: BufferedAction): boolean, string
---@field IsValid fun(self: BufferedAction): boolean
---@field GetActionString fun(self: BufferedAction): string
---@field GetActionPoint fun(self: BufferedAction): Point | nil

---@class Transform
---@field GetWorldPosition fun(self: Transform): number, number, number
---@field GetRotation fun(self: Transform): number

---@class Entity
---@field IsValid fun(self: Entity): boolean
---@field HasTag fun(self: Entity, tag: string): boolean
---@field AddTag fun(self: Entity, tag: string): nil
---@field RemoveTag fun(self: Entity, tag: string): nil
---@field Hide fun(self: Entity, force: boolean | nil): nil
---@field Show fun(self: Entity, force: boolean | nil): nil
---@field IsVisible fun(self: Entity): boolean
---@field GetParent fun(self: Entity): Prefab | nil

-------------------- Components --------------------

---@class Talker
---@field Say fun(self: Talker, script: string, time: number | nil, noanim: boolean | nil, force: boolean | nil, nobroadcast: boolean | nil, colour: any, text_filter_context: any, original_author_netid: number | nil): nil

---@class PlayerController
---@field ismastersim boolean
---@field locomotor Locomotor
---@field Activate fun(self: PlayerController): nil
---@field Deactivate fun(self: PlayerController): nil
---@field EncodeControlMods fun(self: PlayerController): nil
---@field ClearControlMods fun(self: PlayerController): nil
---@field CanLocomote fun(self: PlayerController): nil
---@field IsBusy fun(self: PlayerController): boolean
---@field IsDoingOrWorking fun(self: PlayerController): boolean
---@field GetCursorInventoryObject fun(self: PlayerController): Prefab
---@field GetCursorInventorySlotAndContainer fun(self: PlayerController): number, ContainerReplica
---@field DoControllerActionButton fun(self: PlayerController): nil
---@field DoControllerAltActionButton fun(self: PlayerController): nil
---@field DoControllerAttackButton fun(self: PlayerController, target: Prefab): nil
---@field DoControllerDropItemFromInvTile fun(self: PlayerController, item: Prefab, single: boolean | nil): nil
---@field DoControllerInspectItemFromInvTile fun(self: PlayerController, item: Prefab): nil
---@field DoControllerUseItemOnSelfFromInvTile fun(self: PlayerController, item: Prefab): nil
---@field DoControllerUseItemOnSceneFromInvTile fun(self: PlayerController, item: Prefab): nil
---@field DoAttackButton fun(self: PlayerController, target: Prefab): nil
---@field RemoteAttackButton fun(self: PlayerController, target: Prefab, force_attack): nil
---@field GetActionButtonAction fun(self: PlayerController, force_target: Prefab): BufferedAction | nil
---@field DoActionButton fun(self: PlayerController): nil
---@field GetInspectButtonAction fun(self: PlayerController, target: Prefab): BufferedAction | nil
---@field DoInspectButton fun(self: PlayerController): nil
---@field GetResurrectButtonAction fun(self: PlayerController): BufferedAction | nil
---@field DoResurrectButton fun(self: PlayerController): nil
---@field RotLeft fun(self: PlayerController): nil
---@field RotRight fun(self: PlayerController): nil
---@field ClearActionHold fun(self: PlayerController): nil
---@field RepeatHeldAction fun(self: PlayerController): nil
---@field DoPredictHopping fun(self: PlayerController): nil
---@field DoPredictWalking fun(self: PlayerController, dt: number): nil
---@field DoDragWalking fun(self: PlayerController, dt: number): nil
---@field DoBoatSteering fun(self: PlayerController, dt: number): nil
---@field DoDirectWalking fun(self: PlayerController, dt: number): nil
---@field DoAction fun(self: PlayerController, buffaction: BufferedAction): nil
---@field DoActionAutoEquip fun(self: PlayerController, buffaction: BufferedAction): nil
---@field GetPlatformRelativePosition fun(self: PlayerController, absolute_x: number,absolute_z: number): Prefab | nil, number, number platform, x, z
---@field GetLeftMouseAction fun(self: PlayerController): BufferedAction | nil
---@field GetRightMouseAction fun(self: PlayerController): BufferedAction | nil
---@field GetItemSelfAction fun(self: PlayerController, item: Prefab): BufferedAction | nil
---@field GetSceneItemControllerAction fun(self: PlayerController, item: Prefab): BufferedAction | nil
---@field GetGroundUseAction fun(self: PlayerController, position: Point): BufferedAction | nil
---@field GetGroundUseSpecialAction fun(self: PlayerController, position: Point, right: boolean): BufferedAction | nil
---@field HasGroundUseSpecialAction fun(self: PlayerController, right: boolean): boolean
---@field GetItemUseAction fun(self: PlayerController, active_item: Prefab, target: Prefab): BufferedAction | nil

---@class PlayerActionPicker
---@field HasContainerWidgetAction fun(self: PlayerActionPicker): boolean
---@field GetSceneActions fun(self: PlayerActionPicker, useitem: Prefab, right): BufferedAction[]
---@field GetUseItemActions fun(self: PlayerActionPicker, target: Prefab, useitem: Prefab, right: boolean): BufferedAction[]
---@field GetSteeringActions fun(self: PlayerActionPicker, inst: PlayerPrefab, pos: Point, right: boolean): BufferedAction[]
---@field GetPointActions fun(self: PlayerActionPicker, pos: Point, useitem: Prefab, right: boolean): BufferedAction[]
---@field GetPointSpecialActions fun(self: PlayerActionPicker, pos: Point, useitem: Prefab, right: boolean): BufferedAction[]
---@field GetEquippedItemActions fun(self: PlayerActionPicker, target: Prefab, useitem: Prefab, right: boolean): BufferedAction[]
---@field GetInventoryActions fun(self: PlayerActionPicker, useitem: Prefab, right: boolean): BufferedAction[]
---@field GetLeftClickActions fun(self: PlayerActionPicker, position: Point, target: Prefab): BufferedAction[]
---@field GetRightClickActions fun(self: PlayerActionPicker, position: Point, target: Prefab): BufferedAction[]
---@field DoGetMouseActions fun(self: PlayerActionPicker, position: Point, target: Prefab): BufferedAction, BufferedAction | nil

---@class Locomotor
---@field walkspeed number
---@field runspeed number
---@field slowmultiplier number
---@field fastmultiplier number
---@field groundspeedmultiplier number
---@field isrunning boolean
---@field _externalspeedmultipliers table<string, number>
---@field externalspeedmultiplier number
---@field is_prediction_enabled boolean
---@field StopMoving fun(self: Locomotor): nil
---@field GetWalkSpeed fun(self: Locomotor): number
---@field GetRunSpeed fun(self: Locomotor): number
---@field WalkForward fun(self: Locomotor, direct: boolean | nil): nil
---@field RunForward fun(self: Locomotor, direct: boolean | nil): nil
---@field Clear fun(self: Locomotor): nil
---@field ResetPath fun(self: Locomotor): nil
---@field KillPathSearch fun(self: Locomotor): nil
---@field GoToEntity fun(self: Locomotor, target: Prefab, bufferedaction: BufferedAction | nil, run: boolean | nil): nil
---@field GoToPoint fun(self: Locomotor, pt: Point, bufferedaction: BufferedAction | nil, run: boolean | nil, overridedest: Prefab | nil): nil
---@field Stop fun(self: Locomotor, sgparams: any): nil
---@field WalkInDirection fun(self: Locomotor, direction: number | nil, should_run: boolean | nil): nil
---@field RunInDirection fun(self: Locomotor, direction: number | nil, throttle: number | nil): nil
---@field HasDestination fun(self: Locomotor): boolean
---@field WantsToRun fun(self: Locomotor): boolean
---@field WantsToMoveForward fun(self: Locomotor): boolean
---@field FinishHopping fun(self: Locomotor): boolean
---@field CheckEdgefun fun(self: Locomotor, my_platform: Prefab, map: TheMap, my_x: number, my_z: number, dir_x: number, dir_z: number, radius: number): boolean
---@field IsAtEdge fun(self: Locomotor, my_platform: Prefab, map: TheMap, my_x: number, my_z: number, dir_x: number, dir_z: number): boolean
---@field IsAquatic fun(self: Locomotor): boolean
---@field CanPathfindOnWater fun(self: Locomotor): boolean
---@field IsTerrestrial fun(self: Locomotor): boolean
---@field CanPathfindOnLand fun(self: Locomotor): boolean
---@field PreviewAction fun(self: Locomotor, buffered_action: BufferedAction, run: boolean | nil, try_instant: any): nil

-------------------- Replicas --------------------

---@class ContainerReplica
---@field _isopen boolean
---@field _cannotbeopened NetBool
---@field _numslots integer
---@field acceptsstacks boolean
---@field usespecificslotsforitems boolean
---@field issidewidget boolean
---@field openers Prefab[]
---@field opener Prefab | nil
---@field AttachOpener fun(self: ContainerReplica, opener: PlayerPrefab): nil
---@field DetachOpener fun(self: ContainerReplica): nil
---@field AddOpener fun(self: ContainerReplica, opener: PlayerPrefab): nil
---@field RemoveOpener fun(self: ContainerReplica, opener: PlayerPrefab): nil
---@field GetWidget fun(self: ContainerReplica): ContainerWidget
---@field GetNumSlots fun(self: ContainerReplica): integer
---@field CanBeOpened fun(self: ContainerReplica): boolean
---@field CanTakeItemInSlot fun(self: ContainerReplica, item: Prefab, slot: integer): boolean
---@field GetSpecificSlotForItem fun(self: ContainerReplica, item: Prefab): integer
---@field ShouldPrioritizeContainer fun(self: ContainerReplica, item: Prefab): nil
---@field AcceptsStacks fun(self: ContainerReplica): boolean
---@field IsSideWidget fun(self: ContainerReplica): boolean
---@field IsOpenedBy fun(self: ContainerReplica, guy: PlayerPrefab): boolean
---@field IsHolding fun(self: ContainerReplica, item: Prefab, checkcontainer: boolean | nil): boolean
---@field GetItemInSlot fun(self: ContainerReplica, slot: integer): Prefab
---@field GetItems fun(self: ContainerReplica): Prefab[]
---@field IsEmpty fun(self: ContainerReplica): boolean
---@field IsFull fun(self: ContainerReplica): boolean
---@field Has fun(self: ContainerReplica, prefab: string, amount: integer): boolean
---@field HasItemWithTag fun(self: ContainerReplica, tag: string, amount: integer): boolean
---@field Open fun(self: ContainerReplica, doer): nil
---@field Close fun(self: ContainerReplica): nil
---@field IsBusy fun(self: ContainerReplica): boolean
---@field PutOneOfActiveItemInSlot fun(self: ContainerReplica, slot: integer): nil
---@field PutAllOfActiveItemInSlot fun(self: ContainerReplica, slot: integer): nil
---@field TakeActiveItemFromHalfOfSlot fun(self: ContainerReplica, slot: integer): nil
---@field TakeActiveItemFromAllOfSlot fun(self: ContainerReplica, slot: integer): nil
---@field AddOneOfActiveItemToSlot fun(self: ContainerReplica, slot: integer): nil
---@field AddAllOfActiveItemToSlot fun(self: ContainerReplica, slot: integer): nil
---@field SwapActiveItemWithSlot fun(self: ContainerReplica, slot: integer): nil
---@field SwapOneOfActiveItemWithSlot fun(self: ContainerReplica, slot: integer): nil
---@field MoveItemFromAllOfSlot fun(self: ContainerReplica, slot: integer, container: Prefab): nil
---@field MoveItemFromHalfOfSlot fun(self: ContainerReplica, slot: integer, container: Prefab): nil

---@class InventoryReplica
---@field OnOpen fun(self: InventoryReplica): nil
---@field OnClose fun(self: InventoryReplica): nil
---@field OnShow fun(self: InventoryReplica): nil
---@field OnHide fun(self: InventoryReplica): nil
---@field GetNumSlots fun(self: InventoryReplica): integer
---@field CanTakeItemInSlot fun(self: InventoryReplica, item: Prefab, slot: integer): boolean
---@field AcceptsStacks fun(self: InventoryReplica): boolean
---@field IgnoresCanGoInContainer fun(self: InventoryReplica): boolean
---@field EquipHasTag fun(self: InventoryReplica, tag: string): boolean
---@field IsHeavyLifting fun(self: InventoryReplica): boolean
---@field IsVisible fun(self: InventoryReplica): boolean
---@field IsOpenedBy fun(self: InventoryReplica, guy: PlayerPrefab): boolean
---@field IsHolding fun(self: InventoryReplica, item: Prefab, checkcontainer: boolean): boolean
---@field GetActiveItem fun(self: InventoryReplica): Prefab | nil
---@field GetItemInSlot fun(self: InventoryReplica, slot: integer): Prefab | nil
---@field GetEquippedItem fun(self: InventoryReplica, eslot: string): Prefab | nil
---@field GetItems fun(self: InventoryReplica): Prefab[]
---@field GetEquips fun(self: InventoryReplica): Prefab[]
---@field GetOpenContainers fun(self: InventoryReplica): table<string, boolean>
---@field GetOverflowContainer fun(self: InventoryReplica): ContainerReplica | nil
---@field IsFull fun(self: InventoryReplica): boolean
---@field Has fun(self: InventoryReplica, prefab: string, amount: integer): boolean
---@field HasItemWithTag fun(self: InventoryReplica, tag: string, amount: integer): boolean
---@field ReturnActiveItem fun(self: InventoryReplica): nil
---@field PutOneOfActiveItemInSlot fun(self: InventoryReplica, slot: integer): nil
---@field PutAllOfActiveItemInSlot fun(self: InventoryReplica, slot: integer): nil
---@field TakeActiveItemFromHalfOfSlot fun(self: InventoryReplica, slot: integer): nil
---@field TakeActiveItemFromAllOfSlot fun(self: InventoryReplica, slot: integer): nil
---@field AddOneOfActiveItemToSlot fun(self: InventoryReplica, slot: integer): nil
---@field AddAllOfActiveItemToSlot fun(self: InventoryReplica, slot: integer): nil
---@field SwapActiveItemWithSlot fun(self: InventoryReplica, slot: integer): nil
---@field UseItemFromInvTile fun(self: InventoryReplica, item: Prefab): nil
---@field ControllerUseItemOnItemFromInvTile fun(self: InventoryReplica, item: Prefab, active_item: Prefab): nil
---@field ControllerUseItemOnSelfFromInvTile fun(self: InventoryReplica, item: Prefab): nil
---@field ControllerUseItemOnSceneFromInvTile fun(self: InventoryReplica, item: Prefab): nil
---@field InspectItemFromInvTile fun(self: InventoryReplica, item: Prefab): nil
---@field DropItemFromInvTile fun(self: InventoryReplica, item: Prefab, single: boolean | nil): nil
---@field EquipActiveItem fun(self: InventoryReplica): nil
---@field EquipActionItem fun(self: InventoryReplica, item: Prefab): nil
---@field SwapEquipWithActiveItem fun(self: InventoryReplica): nil
---@field TakeActiveItemFromEquipSlot fun(self: InventoryReplica, eslot: integer): nil
---@field MoveItemFromAllOfSlot fun(self: InventoryReplica, slot: integer, container: Prefab): nil
---@field MoveItemFromHalfOfSlot fun(self: InventoryReplica, slot: integer, container: Prefab): nil

---@class GfTrade
---@field GetGfCoin fun(self: GfTrade): integer
---@field GetReserveCoin fun(self: GfTrade): integer
---@field GetIntegral fun(self: GfTrade): integer
---@field Afford fun(self: GfTrade, cost: number): boolean

---@class GfLevel
---@field GetLevel fun(self: GfLevel): integer
---@field exp NetNumber
---@field expceiling NetNumber

---@class GfPlayerSkillRegister
---@field GetSkillData fun(self: GfPlayerSkillRegister, slot: integer): Skill | nil
---@field GetSkillCd fun(self: GfPlayerSkillRegister, slot: integer): number
---@field Trigger fun(self: GfPlayerSkillRegister, slot: integer): nil

---@class HealthReplica
---@field Max fun(self: HealthReplica): number
---@field MaxWithPenalty fun(self: HealthReplica): number
---@field GetPercent fun(self: HealthReplica): number from 0.0 to 1.0
---@field GetCurrent fun(self: HealthReplica): number
---@field GetPenaltyPercent fun(self: HealthReplica): number from 0.0 (no penalty) to 1.0
---@field IsHurt fun(self: HealthReplica): boolean
---@field IsDead fun(self: HealthReplica): boolean
---@field IsTakingFireDamage fun(self: HealthReplica): boolean
---@field IsTakingFireDamageLow fun(self: HealthReplica): boolean
---@field IsTakingFireDamageFull fun(self: HealthReplica): boolean
---@field CanHeal fun(self: HealthReplica): boolean
---@field CanMurder fun(self: HealthReplica): boolean

---@class HungerReplica
---@field Max fun(self: HungerReplica): number
---@field GetPercent fun(self: HungerReplica): number from 0.0 to 1.0
---@field GetCurrent fun(self: HungerReplica): number
---@field IsStarving fun(self: HungerReplica): boolean

---@class SanityReplica
---@field Max fun(self: SanityReplica): number
---@field MaxWithPenalty fun(self: SanityReplica): number
---@field GetPercent fun(self: SanityReplica): number from 0.0 to 1.0
---@field GetPercentNetworked fun(self: SanityReplica): number from 0.0 to 1.0
---@field GetCurrent fun(self: SanityReplica): number
---@field GetPercentWithPenalty fun(self: SanityReplica): nil
---@field GetPenaltyPercent fun(self: SanityReplica): number from 0.0 to 1.0
---@field GetRateScale fun(self: SanityReplica): number
---@field IsSane fun(self: SanityReplica): boolean
---@field IsInsane fun(self: SanityReplica): boolean
---@field IsEnlightened fun(self: SanityReplica): boolean
---@field IsCrazy fun(self: SanityReplica): boolean
---@field GetSanityMode fun(self: SanityReplica): integer
---@field IsInsanityMode fun(self: SanityReplica): boolean
---@field IsLunacyMode fun(self: SanityReplica): boolean
---@field IsGhostDrain fun(self: SanityReplica): boolean

---@class CombatReplica
---@field SetTarget fun(self: CombatReplica, target: Prefab): nil
---@field GetTarget fun(self: CombatReplica): Prefab
---@field SetLastTarget fun(self: CombatReplica, target: Prefab): nil
---@field IsRecentTarget fun(self: CombatReplica, target: Prefab): boolean
---@field GetAttackRangeWithWeapon fun(self: CombatReplica): number
---@field GetWeapon fun(self: CombatReplica): Prefab
---@field SetMinAttackPeriod fun(self: CombatReplica, period: number): nil
---@field MinAttackPeriod fun(self: CombatReplica): number
---@field StartAttack fun(self: CombatReplica): nil
---@field CancelAttack fun(self: CombatReplica): nil
---@field InCooldown fun(self: CombatReplica): boolean
---@field CanAttack fun(self: CombatReplica, target: Prefab): boolean
---@field LocomotorCanAttack fun(self: CombatReplica, reached_dest: number, target: Prefab): boolean
---@field CanExtinguishTarget fun(self: CombatReplica, target: Prefab, weapon: Prefab | nil): boolean
---@field CanLightTarget fun(self: CombatReplica, target: Prefab, weapon: Prefab | nil): boolean
---@field CanHitTarget fun(self: CombatReplica, target: Prefab): boolean
---@field IsValidTarget fun(self: CombatReplica, target: Prefab): boolean
---@field CanTarget fun(self: CombatReplica, target: Prefab): boolean
---@field IsAlly fun(self: CombatReplica, guy: Prefab): boolean
---@field TargetHasFriendlyLeader fun(self: CombatReplica, target: Prefab): boolean
---@field CanBeAttacked fun(self: CombatReplica, attacker: Prefab): boolean

---@class InventoryItemReplica
---@field classified InventoryItemClassified
---@field CanBePickedUp fun(self: InventoryItemReplica): boolean
---@field CanGoInContainer fun(self: InventoryItemReplica): boolean
---@field CanOnlyGoInPocket fun(self: InventoryItemReplica): boolean
---@field IsHeld fun(self: InventoryItemReplica): boolean
---@field IsHeldBy fun(self: InventoryItemReplica, guy: PlayerPrefab): boolean
---@field IsGrandOwner fun(self: InventoryItemReplica, guy: PlayerPrefab): boolean
---@field GetPickupPos fun(self: InventoryItemReplica): Point
---@field IsDeployable fun(self: InventoryItemReplica, deployer: PlayerPrefab): boolean
---@field DeploySpacingRadius fun(self: InventoryItemReplica): number
---@field CanDeploy fun(self: InventoryItemReplica, pt: Point, mouseover: Prefab | nil, deployer: PlayerPrefab, rot: number | nil): boolean
---@field SetUseGridPlacer fun(self: InventoryItemReplica, usegridplacer): nil
---@field GetDeployPlacerName fun(self: InventoryItemReplica): nil
---@field AttackRange fun(self: InventoryItemReplica): number
---@field IsWeapon fun(self: InventoryItemReplica): boolean
---@field GetWalkSpeedMult fun(self: InventoryItemReplica): number
---@field GetEquipRestrictedTag fun(self: InventoryItemReplica): string | nil
---@field GetMoisture fun(self: InventoryItemReplica): number
---@field IsWet fun(self: InventoryItemReplica): boolean

---@class BuilderReplica
---@field GetTechBonuses fun(self: BuilderReplica): table<string, number>
---@field IngredientMod fun(self: BuilderReplica): number
---@field GetTechTrees fun(self: BuilderReplica): any
---@field BufferBuild fun(self: BuilderReplica, recipename: string): nil
---@field IsBuildBuffered fun(self: BuilderReplica, recipename: string): boolean
---@field HasCharacterIngredient fun(self: BuilderReplica, ingredient: Ingredient): boolean
---@field HasTechIngredient fun(self: BuilderReplica, ingredient: Ingredient): boolean
---@field KnowsRecipe fun(self: BuilderReplica, recipename: string): boolean
---@field CanBuild fun(self: BuilderReplica, recipename: string): boolean
---@field CanLearn fun(self: BuilderReplica, recipename: string): boolean
---@field CanBuildAtPoint fun(self: BuilderReplica, pt: Point, recipe: Recipe, rot: number): boolean
---@field MakeRecipeFromMenu fun(self: BuilderReplica, recipe: Recipe, skin: string | nil): nil
---@field MakeRecipeAtPoint fun(self: BuilderReplica, recipe: Recipe, pt: Point, rot: number | nil, skin: string | nil): nil
---@field IsBusy fun(self: BuilderReplica): boolean

---@class StackableReplica
---@field _stacksize NetNumber is equal to actual size - 1
---@field _maxsize NetNumber
---@field StackSize fun(self: StackableReplica): integer
---@field PreviewStackSize fun(self: StackableReplica): integer
---@field MaxSize fun(self: StackableReplica): integer
---@field IsStack fun(self: StackableReplica): boolean
---@field IsPreviewStack fun(self: StackableReplica): boolean
---@field IsFull fun(self: StackableReplica): boolean
---@field IsPreviewFull fun(self: StackableReplica): boolean

---@class EquippableReplica
---@field _equipslot NetNumber
---@field EquipSlot fun(self: EquippableReplica): string
---@field IsEquipped fun(self: EquippableReplica): boolean
---@field IsRestricted fun(self: EquippableReplica, target: Prefab): boolean

---@class OceanFishingRodReplica
---@field _target NetEntity
---@field _line_tension NetNumber
---@field _max_cast_dist NetNumber
---@field GetTarget fun(self: OceanFishingRodReplica): Prefab | nil
---@field IsLineTensionHigh fun(self: OceanFishingRodReplica): boolean
---@field IsLineTensionGood fun(self: OceanFishingRodReplica): boolean
---@field IsLineTensionLow fun(self: OceanFishingRodReplica): boolean
---@field GetMaxCastDist fun(self: OceanFishingRodReplica): number
---@field GetDebugString fun(self: OceanFishingRodReplica): string

-------------------- ClassifiedEntity --------------------

---@class InventoryItemClassified : Prefab
---@field cangoincontainer NetBool
---@field canonlygoinpocket NetBool
---@field src_pos { isvalid: NetBool, x: NetNumber, z: NetNumber }
---@field percentused NetNumber
---@field perish NetNumber
---@field recharge NetNumber
---@field rechargetime NetNumber
---@field deploymode NetNumber
---@field deployspacing NetNumber
---@field deployrestrictedtag NetHash
---@field usegridplacer NetBool
---@field attackrange NetNumber
---@field walkspeedmult NetNumber
---@field equiprestrictedtag NetHash
---@field moisture NetNumber

---@class PlayerClassified: Prefab
---@field _oldhealthpercent number
---@field currenthealth NetNumber
---@field maxhealth NetNumber
---@field healthpenalty NetNumber
---@field istakingfiredamage NetBool
---@field istakingfiredamagelow NetBool
---@field issleephealing NetBool
---@field ishealthpulseup NetBool
---@field ishealthpulsedown NetBool
---@field _oldhungerpercent number
---@field currenthunger NetNumber
---@field maxhunger NetNumber
---@field ishungerpulseup NetBool
---@field ishungerpulsedown NetBool
---@field _oldsanitypercent number
---@field currentsanity NetNumber
---@field maxsanity NetNumber
---@field sanitypenalty NetNumber
---@field sanityratescale NetNumber
---@field issanitypulseup NetBool
---@field issanitypulsedown NetBool
---@field issanityghostdrain NetBool
---@field _oldwerenesspercent number
---@field currentwereness NetNumber
---@field iswerenesspulseup NetBool
---@field iswerenesspulsedown NetBool
---@field werenessdrainrate NetNumber
---@field _oldinspirationpercent number
---@field currentinspiration NetNumber
---@field inspirationdraining NetBool
---@field inspirationsongs NetNumber[]
---@field hasinspirationbuff NetBool
---@field inmightygym NetNumber
---@field gym_bell_start NetEvent
---@field currentmightiness NetNumber
---@field mightinessratescale NetNumber
---@field oldager_yearpercent NetNumber
---@field oldager_rate NetNumber
---@field _oldtemperature number
---@field currenttemperature number
---@field currenttemperaturedata NetNumber
---@field _oldmoisture number
---@field moisture NetNumber
---@field maxmoisture NetNumber
---@field moistureratescale NetNumber
---@field stormlevel NetNumber
---@field stormtype NetNumber
---@field inked NetEvent
---@field _pausepredictiontask any
---@field pausepredictionframes NetNumber
---@field iscontrollerenabled NetBool
---@field voteselection NetNumber
---@field votesquelched NetBool
---@field ishudvisible NetBool
---@field ismapcontrolsvisible NetBool
---@field isactionsvisible NetBool
---@field cameradistance NetNumber
---@field iscamerazoomed NetBool
---@field camerasnap NetBool
---@field camerashakemode NetNumber
---@field camerashaketime NetNumber
---@field camerashakespeed NetNumber
---@field camerashakescale NetNumber
---@field isfadein NetBool
---@field fadetime NetNumber
---@field screenflash NetNumber
---@field wormholetravelevent NetNumber
---@field houndwarningevent NetNumber
---@field start_farming_music NetEvent
---@field buildevent NetEvent
---@field builderdamagedevent NetEvent
---@field learnrecipeevent NetEvent
---@field techtrees any
---@field ingredientmod NetNumber
---@field isfreebuildmode NetBool
---@field recipes Recipe[]
---@field bufferedbuilds table<string, NetBool>
---@field learnmapevent NetEvent
---@field revealmapspotevent NetEvent
---@field revealmapspot_worldx NetNumber
---@field revealmapspot_worldz NetNumber
---@field repairevent NetEvent
---@field hasyotbskin NetBool
---@field hasgift NetBool
---@field hasgiftmachine NetBool
---@field lastcombattarget NetEntity
---@field canattack NetBool
---@field minattackperiod NetNumber
---@field attackedpulseevent NetEvent
---@field isattackedbydanger NetBool
---@field isattackredirected NetBool
---@field makefriendevent NetEvent
---@field feedincontainerevent NetEvent
---@field ridermount NetEntity
---@field ridersaddle NetEntity
---@field isridermounthurt NetBool
---@field riderrunspeed NetNumber
---@field riderfasteronroad NetBool
---@field touchstonetrackerused NetNumberArray
---@field isperformactionsuccess NetBool
---@field isghostmode NetBool
---@field actionmeter NetNumber
---@field actionmetertime NetNumber
---@field runspeed NetNumber
---@field externalspeedmultiplier NetNumber
---@field iscarefulwalking NetBool
---@field isdeathbypk NetBool
---@field deathcause NetHash

-------------------- Component and Replica --------------------

---@class Components
---@field talker Talker | nil
---@field playercontroller PlayerController | nil
---@field playeractionpicker PlayerActionPicker | nil
---@field locomotor Locomotor | nil

---@class ComponentsReplica
---@field container ContainerReplica | nil
---@field inventory InventoryReplica | nil
---@field gftrade GfTrade | nil
---@field gflevel GfLevel | nil
---@field gf_playerskillregister GfPlayerSkillRegister | nil
---@field health HealthReplica | nil
---@field hunger HungerReplica | nil
---@field sanity SanityReplica | nil
---@field combat CombatReplica | nil
---@field inventoryitem InventoryItemReplica | nil
---@field builder BuilderReplica | nil
---@field stackable StackableReplica | nil
---@field equippable EquippableReplica | nil
---@field oceanfishingrod OceanFishingRodReplica | nil

---@class Prefab: SchedulerHost
---@field GUID integer
---@field name string
---@field prefab string
---@field entity Entity
---@field Transform Transform | nil
---@field replica ComponentsReplica
---@field sg StateGraph
---@field Hide fun(self: Prefab): nil
---@field Show fun(self: Prefab): nil
---@field IsInLimbo fun(self: Prefab): boolean
---@field IsValid fun(self: Prefab): boolean
---@field IsAsleep fun(self: Prefab): boolean
---@field IsInLight fun(self: Prefab): boolean
---@field Remove fun(self: Prefab): nil
---@field CanInteractWith fun(self: Prefab, inst: Prefab): boolean
---@field GetTimeAlive fun(self: Prefab): number
---@field HasTag fun(self: Prefab, tag: string): boolean
---@field AddTag fun(self: Prefab, tag: string): nil
---@field RemoveTag fun(self: Prefab, tag: string): nil
---@field GetAdjective fun(self: Prefab): string
---@field GetBasicDisplayName fun(self: Prefab): string
---@field GetAdjectivedName fun(self: Prefab): string
---@field GetDisplayName fun(self: Prefab): string
---@field ListenForEvent fun(self: Prefab, event: string, fn: function, source: string | nil): nil
---@field RemoveEventCallback fun(self: Prefab, event: string, fn: function, source: string): nil
---@field RemoveAllEventCallbacks fun(self: Prefab): nil
---@field PushEvent fun(self: Prefab, event: string, data: any): nil
---@field GetPhysicsRadius fun(self: Prefab, default: number): number
---@field GetPosition fun(self: Prefab): Point
---@field GetRotation fun(self: Prefab): number
---@field GetAngleToPoint fun(self: Prefab, x: number, y: number, z: number): number
---@field GetPositionAdjacentTo fun(self: Prefab, target: Prefab, distance: number): number
---@field GetDistanceSqToInst fun(self: Prefab, inst: Prefab): number
---@field IsNear fun(self: Prefab, otherinst: Prefab, dist: number): number
---@field GetDistanceSqToPoint fun(self: Prefab, x: number, y: number, z: number): number
---@field IsNearPlayer fun(self: Prefab, range: number, isalive: boolean): boolean
---@field GetNearestPlayer fun(self: Prefab, isalive: boolean): Prefab
---@field GetDistanceSqToClosestPlayer fun(self: Prefab, isalive: boolean): number
---@field IsOnValidGround fun(self: Prefab): boolean does not support boats
---@field IsOnPassablePoint fun(self: Prefab, include_water: boolean, floating_platforms_are_not_passable: boolean): boolean
---@field IsOnOcean fun(self: Prefab, allow_boats: boolean): boolean
---@field GetCurrentPlatform fun(self: Prefab): Prefab | nil
---@field GetCurrentTileType fun(self: Prefab): number, table<string, string>
---@field GetPersistData fun(self: Prefab): any
---@field CollectActions fun(self: Prefab, actiontype: 'EQUIPPED' | 'INVENTORY' | 'ISVALID' | 'POINT' | 'SCENE' | 'USEITEM', ...): nil
---@field IsActionValid fun(self: Prefab, action: Action, right: boolean): boolean
---@field GetDebugString fun(self: Prefab): string
---@field net_showme_hint_refresh_out_time__senhai number
---@field on_net_showme_hint_time__senhai number
---@field showme_hint_update_time__senhai number
---@field showme_hint__senhai string
---@field showme_data__senhai ShowMeData | nil

---@class PlayerPrefab : Prefab
---@field userid string
---@field components Components
---@field HUD { controls: table<string, any> }
---@field player_classified PlayerClassified

---@diagnostic disable-next-line: empty-block
if false then
  ---@type PlayerPrefab
  ThePlayer = {}

  ---@type TheSim
  TheSim = {}

  ---@type TheWorld
  TheWorld = {}

  ---@type TheNet
  TheNet = {}

  ---@type FollowCamera
  TheCamera = {}

  ---@type Input
  TheInput = {}

  ---@type Prefab[]
  Ents = {}

  ---@type { HANDS: string, BODY: string, HEAD: string, BACK: string }
  EQUIPSLOTS = {}

  ---@type table<string, Action>
  ACTIONS = {}

  ---@type PlayerPrefab[]
  AllPlayers = {}

  ---@type table<string, Recipe>
  AllRecipes = {}

  ---@type table<string, integer>
  RPC = {}

  ---@alias ModRpcInst { namespace: string, id: integer }
  ---@type table<string, table<string, ModRpcInst>>
  MOD_RPC = {}

  ---@param code integer
  function SendRPCToServer(code, ...) end

  ---@param id_table ModRpcInst
  function SendModRPCToServer(id_table, ...) end

  ---@type EmberShop
  EBSHOP = {}

  ---@param value any
  ---@param desciption string
  ---@param nesting number
  ---@diagnostic disable-next-line: lowercase-global
  function c_dir(value, desciption, nesting) end

  ---@param prefab string
  ---@param radius number | nil
  ---@param inst Prefab | nil
  ---@return Prefab | nil
  ---@diagnostic disable-next-line: lowercase-global
  function c_find(prefab, radius, inst) end

  ---@param x number
  ---@param y number
  ---@param z number
  ---@return Point
  function Point(x, y, z) end

  ---@param inst Prefab
  ---@param target Prefab
  ---@param action Action
  ---@return BufferedAction
  function BufferedAction(inst, target, action) end

  Vector3 = Point

  ---@param fn function
  ---@param id string
  ---@param param any
  ---@return Task
  function StartThread(fn, id, param) end

  ---@return number
  function GetTime() end

  ---@param task Task
  ---@return nil
  function KillThread(task) end

  ---@param time number second
  ---@return nil
  function Sleep(time) end

  ---@param key string
  ---@return string | number | boolean
  function GetModConfigData(key) end

  ---@param name string
  ---@return Prefab
  function CreateEntity(name) end

  ---@param inst Prefab
  ---@param mass number
  ---@param rad number
  ---@return nil
  function MakeInventoryPhysics(inst, mass, rad) end

  ---@param inst Prefab
  ---@return nil
  function RemovePhysicsColliders(inst) end

  ---@param inst Prefab
  ---@param radius number
  ---@param fn fun(v: Prefab, inst: Prefab): boolean
  ---@param musttags string[] | nil
  ---@param canttags string[] | nil
  ---@param mustoneoftags string[] | nil
  ---@return Prefab | nil
  function FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags) end

  ---@param fn fun(inst: PlayerPrefab): nil
  function AddPlayerPostInit(fn) end

  ---@param prefab string
  ---@param fn fun(inst: Prefab): nil
  function AddPrefabPostInit(prefab, fn) end

  ---@param class string
  ---@param fn fun(inst: any): nil
  function AddClassPostConstruct(class, fn) end
end

-- ---@generic T
-- ---@param param1 T
-- ---@param param2 fun(v: T): nil
-- ---@return T
-- local function test(param1, param2) end

-- ---@type Prefab
-- local car = {}

-- local v1 = test(car, function(c)
--   c.Transform:GetWorldPosition()
-- end)
